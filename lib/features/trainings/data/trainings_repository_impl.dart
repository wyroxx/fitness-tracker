import 'package:dio/dio.dart';
import 'package:fitness_tracker/core/logging/app_logger.dart';
import 'package:fitness_tracker/core/network/api_exception_mapper.dart';
import 'package:fitness_tracker/core/network/dio_provider.dart';
import 'package:fitness_tracker/features/trainings/data/models/create_training_request.dart';
import 'package:fitness_tracker/features/trainings/data/models/training.dart';
import 'package:fitness_tracker/features/trainings/domain/trainings_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final trainingsRepositoryProvider = Provider<TrainingsRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final logger = ref.watch(loggerProvider);
  return TrainingsRepositoryImpl(dio, logger);
});

final trainingsProvider = FutureProvider<List<Training>>((ref) async {
  final repository = ref.watch(trainingsRepositoryProvider);
  return repository.getTrainings();
});

class TrainingsRepositoryImpl implements TrainingsRepository {
  final Dio _dio;
  final Logger _logger;

  TrainingsRepositoryImpl(this._dio, this._logger);

  @override
  Future<List<Training>> getTrainings() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/trainings');
      final data = response.data;

      if (data == null) {
        return [];
      }

      final items = data['items'] as List<dynamic>? ?? [];
      _logger.i('Parsed ${items.length} trainings for current user');
      return items
          .map((json) => Training.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      final exception = mapDioException(e);
      _logger.w('Could not load trainings: ${exception.message}');
      throw exception;
    }
  }

  @override
  Future<void> createTraining(CreateTrainingRequest request) async {
    try {
      await _dio.post('/trainings', data: request.toJson());
      _logger.i('Created new training successfully');
    } on DioException catch (e) {
      final exception = mapDioException(e);
      _logger.w('Could not create training: ${exception.message}');
      throw exception;
    }
  }

  @override
  Future<void> deleteTraining(int id) async {
    try {
      await _dio.delete('/trainings/$id');
      _logger.i('Deleted training $id');
    } on DioException catch (e) {
      _logger.w('Could not delete training $id');
      throw mapDioException(e);
    }
  }
}

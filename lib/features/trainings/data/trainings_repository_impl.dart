import 'package:dio/dio.dart';
import 'package:fitness_tracker/core/network/dio_provider.dart';
import 'package:fitness_tracker/features/trainings/data/models/training.dart';
import 'package:fitness_tracker/features/trainings/domain/trainings_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final trainingsRepositoryProvider = Provider<TrainingsRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return TrainingsRepositoryImpl(dio);
});

final trainingsProvider = FutureProvider<List<Training>>((ref) async {
  final repository = ref.watch(trainingsRepositoryProvider);
  return repository.getTrainings();
});

class TrainingsRepositoryImpl implements TrainingsRepository {
  final Dio _dio;

  TrainingsRepositoryImpl(this._dio);

  @override
  Future<List<Training>> getTrainings() async {
    final response = await _dio.get<Map<String, dynamic>>('/trainings');
    final data = response.data;

    if (data == null) {
      return [];
    }

    final items = data['items'] as List<dynamic>? ?? [];

    return items
        .map((json) => Training.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> createTraining(Training training) async {
    await _dio.post('/trainings', data: training.toJson());
  }
}

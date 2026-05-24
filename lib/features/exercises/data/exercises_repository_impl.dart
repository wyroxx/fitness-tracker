import 'package:dio/dio.dart';
import 'package:fitness_tracker/core/logging/app_logger.dart';
import 'package:fitness_tracker/core/network/api_exception_mapper.dart';
import 'package:fitness_tracker/core/network/dio_provider.dart';
import 'package:fitness_tracker/features/exercises/data/models/exercise.dart';
import 'package:fitness_tracker/features/exercises/domain/exercises_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final exercisesRepositoryProvider = Provider<ExercisesRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final logger = ref.watch(loggerProvider);
  return ExercisesRepositoryImpl(dio, logger);
});

final exercisesProvider = FutureProvider.family<List<Exercise>, int>((
  ref,
  id,
) async {
  final repository = ref.watch(exercisesRepositoryProvider);
  return repository.getExercises(id);
});

class ExercisesRepositoryImpl implements ExercisesRepository {
  final Dio _dio;
  final Logger _logger;

  ExercisesRepositoryImpl(this._dio, this._logger);

  @override
  Future<List<Exercise>> getExercises(int muscleGroupId) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/muscle-groups/$muscleGroupId/workout-types',
      );
      final data = response.data;
      if (data == null) {
        return [];
      }
      _logger.i('Parsed ${data.length} exercises for group $muscleGroupId');
      return data.map((json) => Exercise.fromJson(json)).toList();
    } on DioException catch (e) {
      final exception = mapDioException(e);
      _logger.w(
        'Could not load exercises for group $muscleGroupId: ${exception.message}',
      );
      throw exception;
    }
  }
}

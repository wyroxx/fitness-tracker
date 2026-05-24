import 'package:dio/dio.dart';
import 'package:fitness_tracker/core/network/api_exception_mapper.dart';
import 'package:fitness_tracker/core/network/dio_provider.dart';
import 'package:fitness_tracker/features/exercises/data/models/exercise.dart';
import 'package:fitness_tracker/features/exercises/domain/exercises_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exercisesRepositoryProvider = Provider<ExercisesRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ExercisesRepositoryImpl(dio);
});

final exercisesProvider = FutureProvider.family<List<Exercise>, int>((ref, id) async {
  final repository = ref.watch(exercisesRepositoryProvider);
  return repository.getExercises(id);
});

class ExercisesRepositoryImpl implements ExercisesRepository {
  final Dio _dio;

  ExercisesRepositoryImpl(this._dio);
  
  @override
  Future<List<Exercise>> getExercises(int muscleGroupId) async {
    try {
      final response = await _dio.get<List<dynamic>>('/muscle-groups/$muscleGroupId/workout-types');
      final data = response.data;
      if (data == null) {
        return [];
      }
      return data.map((json) => Exercise.fromJson(json)).toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}

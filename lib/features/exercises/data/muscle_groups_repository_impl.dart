import 'package:dio/dio.dart';
import 'package:fitness_tracker/core/network/api_exception.dart';
import 'package:fitness_tracker/core/network/dio_provider.dart';
import 'package:fitness_tracker/features/exercises/data/models/muscle_group.dart';
import 'package:fitness_tracker/features/exercises/domain/muscle_groups_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final muscleGroupsRepositoryProvider = Provider<MuscleGroupsRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return MuscleGroupsRepositoryImpl(dio);
});

final muscleGroupsProvider = FutureProvider((ref) async {
  final repository = ref.watch(muscleGroupsRepositoryProvider);
  return repository.getMuscleGroups();
});

class MuscleGroupsRepositoryImpl implements MuscleGroupsRepository {
  final Dio _dio;

  MuscleGroupsRepositoryImpl(this._dio);

  @override
  Future<List<MuscleGroup>> getMuscleGroups() async {
    try {
      final response = await _dio.get<List<dynamic>>('/muscle-groups');
      final data = response.data;
      if (data == null) {
        return [];
      }
      return data.map((json) => MuscleGroup.fromJson(json)).toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}

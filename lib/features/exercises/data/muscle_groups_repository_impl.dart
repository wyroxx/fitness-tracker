import 'package:dio/dio.dart';
import 'package:fitness_tracker/core/logging/app_logger.dart';
import 'package:fitness_tracker/core/network/api_exception_mapper.dart';
import 'package:fitness_tracker/core/network/dio_provider.dart';
import 'package:fitness_tracker/features/exercises/data/models/muscle_group.dart';
import 'package:fitness_tracker/features/exercises/domain/muscle_groups_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final muscleGroupsRepositoryProvider = Provider<MuscleGroupsRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final logger = ref.watch(loggerProvider);
  return MuscleGroupsRepositoryImpl(dio, logger);
});

final muscleGroupsProvider = FutureProvider((ref) async {
  final repository = ref.watch(muscleGroupsRepositoryProvider);
  return repository.getMuscleGroups();
});

class MuscleGroupsRepositoryImpl implements MuscleGroupsRepository {
  final Dio _dio;
  final Logger _logger;

  MuscleGroupsRepositoryImpl(this._dio, this._logger);

  @override
  Future<List<MuscleGroup>> getMuscleGroups() async {
    try {
      final response = await _dio.get<List<dynamic>>('/muscle-groups');
      final data = response.data;
      if (data == null) {
        return [];
      }
      _logger.i('Parsed ${data.length} muscle groups');
      return data.map((json) => MuscleGroup.fromJson(json)).toList();
    } on DioException catch (e) {
      final exception = mapDioException(e);
      _logger.w('Could not load muscle groups: ${exception.message}');
      throw exception;
    }
  }
}

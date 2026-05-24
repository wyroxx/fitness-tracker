import 'package:dio/dio.dart';
import 'package:fitness_tracker/core/logging/app_logger.dart';
import 'package:fitness_tracker/core/network/api_exception.dart';
import 'package:fitness_tracker/core/network/api_exception_mapper.dart';
import 'package:fitness_tracker/core/network/dio_provider.dart';
import 'package:fitness_tracker/features/profile/data/models/profile_data.dart';
import 'package:fitness_tracker/features/profile/data/models/stats.dart';
import 'package:fitness_tracker/features/profile/data/models/user.dart';
import 'package:fitness_tracker/features/profile/domain/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final logger = ref.watch(loggerProvider);
  return ProfileRepositoryImpl(dio, logger);
});

final profileDataProvider = FutureProvider<ProfileData>((ref) async {
  final repository = ref.watch(profileRepositoryProvider);

  final userFuture = repository.getUser();
  final statsFuture = repository.getStats();

  final user = await userFuture;
  final stats = await statsFuture;

  return ProfileData(user: user, stats: stats);
});

class ProfileRepositoryImpl implements ProfileRepository {
  final Dio _dio;
  final Logger _logger;

  ProfileRepositoryImpl(this._dio, this._logger);

  @override
  Future<UserStats> getStats() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/profile/stats');

      final data = response.data;
      if (data == null) {
        throw const UnknownApiException('Stats response is empty');
      }
      _logger.i('Collected statistics for the current user');
      return UserStats.fromJson(data);
    } on DioException catch (e) {
      final exception = mapDioException(e);
      _logger.w('Could not load profile stats: ${exception.message}');
      throw exception;
    }
  }

  @override
  Future<String> getSuggestion() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/suggest-workout');
      final data = response.data;
      if (data == null) {
        return 'Nothing here. Try later.';
      }
      _logger.i('Parsed new workout suggestion');
      return data['suggestion'] as String;
    } on DioException catch (e) {
      final exception = mapDioException(e);
      _logger.w('Could not load workout suggestion: ${exception.message}');
      throw exception;
    }
  }

  @override
  Future<User> getUser() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/users/me');

      final data = response.data;
      if (data == null) {
        throw const UnknownApiException('User response is empty');
      }
      _logger.i('User data collected successfully');
      return User.fromJson(data);
    } on DioException catch (e) {
      final exception = mapDioException(e);
      _logger.w('Could not load current user: ${exception.message}');
      throw exception;
    }
  }
}

import 'package:dio/dio.dart';
import 'package:fitness_tracker/core/network/api_exception.dart';
import 'package:fitness_tracker/core/network/api_exception_mapper.dart';
import 'package:fitness_tracker/core/network/dio_provider.dart';
import 'package:fitness_tracker/features/profile/data/models/profile_data.dart';
import 'package:fitness_tracker/features/profile/data/models/stats.dart';
import 'package:fitness_tracker/features/profile/data/models/user.dart';
import 'package:fitness_tracker/features/profile/domain/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ProfileRepositoryImpl(dio);
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

  ProfileRepositoryImpl(this._dio);

  @override
  Future<UserStats> getStats() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/profile/stats');

      final data = response.data;
      if (data == null) {
        throw const UnknownApiException('Stats response is empty');
      }

      return UserStats.fromJson(data);
    } on DioException catch (e) {
      throw mapDioException(e);
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
      return data['suggestion'] as String;
    } on DioException catch (e) {
      throw mapDioException(e);
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

      return User.fromJson(data);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}

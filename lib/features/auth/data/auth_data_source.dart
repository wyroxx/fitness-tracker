import 'package:dio/dio.dart';
import 'package:fitness_tracker/core/logging/app_logger.dart';
import 'package:fitness_tracker/core/network/api_exception_mapper.dart';
import 'package:fitness_tracker/core/network/dio_provider.dart';
import 'package:fitness_tracker/features/auth/data/models/login_request.dart';
import 'package:fitness_tracker/features/auth/data/models/register_request.dart';
import 'package:fitness_tracker/features/auth/data/models/token_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  final logger = ref.watch(loggerProvider);
  return AuthDataSource(dio, logger);
});

class AuthDataSource {
  final Dio _dio;
  final Logger _logger;

  AuthDataSource(this._dio, this._logger);

  Future<TokenResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: request.toJson(),
      );
      _logger.i('Logged in successfully');
      return TokenResponse.fromJson(response.data!);
    } on DioException catch (e) {
      final exception = mapDioException(e);
      _logger.w('Login request failed: ${exception.message}');
      throw exception;
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
      _logger.i('Logged out successfully');
    } on DioException catch (e) {
      final exception = mapDioException(e);
      _logger.w('Logout request failed: ${exception.message}');
      throw exception;
    }
  }

  Future<void> register(RegisterRequest request) async {
    try {
      await _dio.post<Map<String, dynamic>>('/users', data: request.toJson());
      _logger.i('Account was created successfully');
    } on DioException catch (e) {
      final exception = mapDioException(e);
      _logger.w('Register request failed: ${exception.message}');
      throw exception;
    }
  }
}

import 'package:dio/dio.dart';
import 'package:fitness_tracker/core/network/api_exception_mapper.dart';
import 'package:fitness_tracker/core/network/dio_provider.dart';
import 'package:fitness_tracker/features/auth/data/models/login_request.dart';
import 'package:fitness_tracker/features/auth/data/models/register_request.dart';
import 'package:fitness_tracker/features/auth/data/models/token_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthDataSource(dio);
});

class AuthDataSource {
  final Dio _dio;
  final Logger _logger = Logger(
    printer: SimplePrinter(printTime: false, colors: false),
  );

  AuthDataSource(this._dio);

  Future<TokenResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: request.toJson(),
      );
      _logger.i('Logged in successfully');
      return TokenResponse.fromJson(response.data!);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
      _logger.i('Logged out successfully');
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<void> register(RegisterRequest request) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/users',
        data: request.toJson(),
      );
      _logger.i('Account was created successfully');
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}

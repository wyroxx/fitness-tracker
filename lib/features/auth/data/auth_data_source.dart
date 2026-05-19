import 'package:dio/dio.dart';
import 'package:fitness_tracker/core/network/api_exception.dart';
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
  final Logger _logger = Logger();

  AuthDataSource(this._dio);

  Future<TokenResponse> login(LoginRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: request.toJson(),
    );
    if (response.statusCode == 200) {
      _logger.i('Logged in successfully');
      return TokenResponse.fromJson(response.data!);
    } else if (response.statusCode == 400) {
      throw const BadRequestException();
    } else if (response.statusCode == 401) {
      throw const UnauthorizedException();
    }
    throw const ApiException();
  }

  Future<void> logout() async {
    final response = await _dio.post('/auth/logout');
    if (response.statusCode == 204) {
      _logger.i('Logged out successfully');
      return;
    }
    throw const ApiException();
  }

  Future<TokenResponse> refresh(String refreshToken) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/refresh',
      data: refreshToken,
    );
    if (response.statusCode == 200) {
      _logger.i('Refreshed tokens successfully');
      return TokenResponse.fromJson(response.data!);
    } else if (response.statusCode == 400) {
      throw const BadRequestException();
    } else if (response.statusCode == 401) {
      throw const UnauthorizedException();
    }
    throw const ApiException();
  }

  Future<void> register(RegisterRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/users',
      data: request.toJson(),
    );
    if (response.statusCode == 201) {
      _logger.i('Account was created successfully');
      return;
    } else if (response.statusCode == 400) {
      throw const BadRequestException();
    } else if (response.statusCode == 500) {
      throw const ServerException();
    }
    throw const ApiException();
  }
}

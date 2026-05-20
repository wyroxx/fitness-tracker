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
  final Logger _logger = Logger(
    printer: SimplePrinter(
      printTime: false,
      colors: false
    )
  );

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
      throw BadRequestException(_errorMessage(response));
    } else if (response.statusCode == 401) {
      throw UnauthorizedException(_errorMessage(response));
    }
    throw ApiException(_errorMessage(response));
  }

  Future<void> logout() async {
    final response = await _dio.post('/auth/logout');
    if (response.statusCode == 204) {
      _logger.i('Logged out successfully');
      return;
    }
    throw ApiException(_errorMessage(response));
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
      throw BadRequestException(_errorMessage(response));
    } else if (response.statusCode == 500) {
      throw ServerException(_errorMessage(response));
    }
    throw ApiException(_errorMessage(response));
  }

  String _errorMessage(Response<dynamic> response) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final error = data['error'];
      if (error is String && error.isNotEmpty) {
        return error;
      }
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }
    return 'Request failed with status ${response.statusCode}';
  }
}

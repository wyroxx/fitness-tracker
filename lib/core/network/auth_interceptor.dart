import 'package:dio/dio.dart';
import 'package:fitness_tracker/core/storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final Dio _refreshDio;

  AuthInterceptor({
    required TokenStorage tokenStorage,
    required Dio refreshDio
  }) : _refreshDio = refreshDio,
       _tokenStorage = tokenStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler
  ) async {
    if (_isAuthEndpoint(options.path)) {
      handler.next(options);
      return;
    }

    final String? token = await _tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler
  ) async {
    final statusCode = err.response?.statusCode;
    final options = err.requestOptions;
    if (statusCode != 401 || _isAuthEndpoint(options.path)) {
      handler.next(err);
      return;
    }

    final String? refreshToken = await _tokenStorage.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      await _tokenStorage.clearTokens();
      handler.next(err);
      return;
    }

    try {
      final response = await _refreshDio.post<Map<String, dynamic>>('/auth/refresh');

      final data = response.data;
      if (data == null) {
        await _tokenStorage.clearTokens();
        handler.next(err);
        return;
      }

      await _tokenStorage.saveTokens(
        accessToken: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String
      );

      options.headers['Authorization'] = 'Bearer ${data['access_token']}';
      final retryResponse = await _refreshDio.fetch(options);
      handler.resolve(retryResponse);
    } catch (e) {
      await _tokenStorage.clearTokens();
      handler.next(err);
    }
  }

  bool _isAuthEndpoint(String path) {
    return path.contains('/auth/login')
      || path.contains('/auth/refresh')
      || path.contains('/users');
  }
}

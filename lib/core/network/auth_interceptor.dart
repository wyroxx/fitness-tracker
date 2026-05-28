import 'package:dio/dio.dart';
import 'package:fitness_tracker/core/network/token_refresher.dart';
import 'package:fitness_tracker/core/storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final Dio _refreshDio;
  final TokenRefresher _tokenRefresher;
  final void Function() _onSessionExpired;

  AuthInterceptor({
    required TokenStorage tokenStorage,
    required Dio refreshDio,
    required TokenRefresher tokenRefresher,
    required void Function() onSessionExpired,
  }) : _refreshDio = refreshDio,
       _tokenStorage = tokenStorage,
       _tokenRefresher = tokenRefresher,
       _onSessionExpired = onSessionExpired;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isPublicAuthEndpoint(options)) {
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
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final options = err.requestOptions;
    if (statusCode != 401 || _isPublicAuthEndpoint(options)) {
      handler.next(err);
      return;
    }

    try {
      final currentAccessToken = await _tokenStorage.getAccessToken();
      final failedAccessToken = _accessTokenFromHeader(
        options.headers['Authorization'],
      );

      if (currentAccessToken != null &&
          currentAccessToken.isNotEmpty &&
          currentAccessToken != failedAccessToken) {
        options.headers['Authorization'] = 'Bearer $currentAccessToken';
        final retryResponse = await _refreshDio.fetch(options);
        handler.resolve(retryResponse);
        return;
      }

      final accessToken = await _tokenRefresher.refreshAccessToken();

      if (accessToken == null || accessToken.isEmpty) {
        _onSessionExpired();
        handler.next(err);
        return;
      }

      options.headers['Authorization'] = 'Bearer $accessToken';
      final retryResponse = await _refreshDio.fetch(options);
      handler.resolve(retryResponse);
    } on DioException catch (retryError) {
      if (retryError.response?.statusCode == 401) {
        _onSessionExpired();
      }
      handler.next(err);
    } catch (_) {
      _onSessionExpired();
      handler.next(err);
    }
  }

  String? _accessTokenFromHeader(Object? header) {
    if (header is! String || !header.startsWith('Bearer ')) {
      return null;
    }

    return header.substring('Bearer '.length);
  }

  bool _isPublicAuthEndpoint(RequestOptions options) {
    final path = options.path;
    final method = options.method.toUpperCase();

    return path.contains('/auth/login') ||
        path.contains('/auth/refresh') ||
        (method == 'POST' && path.contains('/users'));
  }
}

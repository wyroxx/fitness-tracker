import 'package:dio/dio.dart';
import 'package:fitness_tracker/core/storage/token_storage.dart';
import 'package:logger/logger.dart';

class TokenRefresher {
  final Dio _refreshDio;
  final TokenStorage _tokenStorage;
  final Logger _logger;

  Future<String?>? _refreshFuture;

  TokenRefresher({
    required Dio refreshDio,
    required TokenStorage tokenStorage,
    required Logger logger,
  }) : _refreshDio = refreshDio,
       _tokenStorage = tokenStorage,
       _logger = logger;

  Future<String?> refreshAccessToken() {
    _refreshFuture ??= _refreshAccessToken();
    return _refreshFuture!.whenComplete(() {
      _refreshFuture = null;
    });
  }

  Future<String?> _refreshAccessToken() async {
    final refreshToken = await _tokenStorage.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      _logger.w('Refresh token is missing');
      await _tokenStorage.clearTokens();
      return null;
    }

    try {
      _logger.i('Refreshing access token');
      final response = await _refreshDio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final data = response.data;
      final accessToken = data?['access_token'] as String?;
      final newRefreshToken = data?['refresh_token'] as String?;

      if (accessToken == null ||
          accessToken.isEmpty ||
          newRefreshToken == null ||
          newRefreshToken.isEmpty) {
        _logger.w('Refresh response is missing tokens');
        await _tokenStorage.clearTokens();
        return null;
      }

      await _tokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: newRefreshToken,
      );

      _logger.i('Access token refreshed successfully');
      return accessToken;
    } catch (e) {
      _logger.w('Could not refresh access token: $e');
      await _tokenStorage.clearTokens();
      return null;
    }
  }
}

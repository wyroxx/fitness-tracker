import 'package:dio/dio.dart';
import 'package:fitness_tracker/core/storage/token_storage.dart';

class TokenRefresher {
  final Dio _refreshDio;
  final TokenStorage _tokenStorage;

  Future<String?>? _refreshFuture;

  TokenRefresher({required Dio refreshDio, required TokenStorage tokenStorage})
    : _refreshDio = refreshDio,
      _tokenStorage = tokenStorage;

  Future<String?> refreshAccessToken() {
    _refreshFuture ??= _refreshAccessToken();
    return _refreshFuture!.whenComplete(() {
      _refreshFuture = null;
    });
  }

  Future<String?> _refreshAccessToken() async {
    final refreshToken = await _tokenStorage.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      await _tokenStorage.clearTokens();
      return null;
    }

    try {
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
        await _tokenStorage.clearTokens();
        return null;
      }

      await _tokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: newRefreshToken,
      );

      return accessToken;
    } catch (_) {
      await _tokenStorage.clearTokens();
      return null;
    }
  }
}

import 'package:fitness_tracker/core/storage/storage_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage();
});

class TokenStorage {
  final _storage = const FlutterSecureStorage();
  final _logger = Logger();

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      await _storage.write(key: 'access_token', value: accessToken);
      await _storage.write(key: 'refresh_token', value: refreshToken);
      _logger.i('Tokens saved successfully');
    } catch (e) {
      _logger.e('Error saving tokens: $e');
      throw const StorageException('Error saving tokens');
    }
  }

  Future<String?> getAccessToken() async {
    try {
      final String? token = await _storage.read(key: 'access_token');
      return token;
    } catch (e) {
      _logger.e('Error reading access token: $e');
      throw const StorageException('Error reading access token');
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      final String? token = await _storage.read(key: 'refresh_token');
      return token;
    } catch (e) {
      _logger.e('Error reading refresh token: $e');
      throw const StorageException('Error reading refresh token');
    }
  }

  Future<void> clearTokens() async {
    try {
      await _storage.delete(key: 'access_token');
      await _storage.delete(key: 'refresh_token');
      _logger.i('Tokens deleted successfully');
    } catch (e) {
      _logger.e('Error deleting tokens: $e');
      throw const StorageException('Error deleting tokens');
    }
  }
}
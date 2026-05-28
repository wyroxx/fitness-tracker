import 'package:fitness_tracker/core/network/api_exception.dart';
import 'package:fitness_tracker/core/network/dio_provider.dart';
import 'package:fitness_tracker/core/network/token_refresher.dart';
import 'package:fitness_tracker/core/storage/storage_exception.dart';
import 'package:fitness_tracker/core/storage/token_storage.dart';
import 'package:fitness_tracker/features/auth/data/auth_data_source.dart';
import 'package:fitness_tracker/features/auth/data/models/login_request.dart';
import 'package:fitness_tracker/features/auth/data/models/register_request.dart';
import 'package:fitness_tracker/features/auth/domain/auth_exception.dart';
import 'package:fitness_tracker/features/auth/domain/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authDataSourceProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);
  final tokenRefresher = ref.watch(tokenRefresherProvider);
  return AuthRepositoryImpl(dataSource, tokenStorage, tokenRefresher);
});

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _dataSource;
  final TokenStorage _tokenStorage;
  final TokenRefresher _tokenRefresher;

  const AuthRepositoryImpl(
    this._dataSource,
    this._tokenStorage,
    this._tokenRefresher,
  );

  @override
  Future<bool> isAuthenticated() async {
    final String? token = await _tokenStorage.getAccessToken();
    if (token != null && !JwtDecoder.isExpired(token)) {
      return true;
    }

    final refreshedToken = await _tokenRefresher.refreshAccessToken();
    return refreshedToken != null && !JwtDecoder.isExpired(refreshedToken);
  }

  @override
  Future<void> login({required String email, required String password}) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _dataSource.login(request);
      await _tokenStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
    } on ApiException catch (e) {
      throw AuthException(e.message);
    } on StorageException {
      throw const AuthException('Could not save tokens');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dataSource.logout();
    } finally {
      await _tokenStorage.clearTokens();
    }
  }

  @override
  Future<void> clearSession() async {
    await _tokenStorage.clearTokens();
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final request = RegisterRequest(
        email: email,
        password: password,
        name: name,
      );
      await _dataSource.register(request);
    } on ApiException catch (e) {
      throw AuthException(e.message);
    } on StorageException {
      throw const AuthException('Could not create the account');
    }
  }
}

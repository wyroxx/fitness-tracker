import 'dart:async';

import 'package:fitness_tracker/features/auth/data/auth_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus {
  loading,
  authenticated,
  unauthenticated,
}

final authControllerProvider = NotifierProvider<AuthController, AuthStatus>(AuthController.new);

class AuthController extends Notifier<AuthStatus> {
  @override
  AuthStatus build() {
    unawaited(_checkAuthStatus());
    return AuthStatus.loading;
  }

  Future<void> _checkAuthStatus() async {
    final repository = ref.read(authRepositoryProvider);

    final isAuthenticated = await repository.isAuthenticated();

    if (isAuthenticated) {
      state = AuthStatus.authenticated;
    } else {
      state = AuthStatus.unauthenticated;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = AuthStatus.loading;
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.login(email: email, password: password);
      state = AuthStatus.authenticated;
    } catch (e) {
      state = AuthStatus.unauthenticated;
      rethrow;
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = AuthStatus.loading;
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.register(
        name: name,
        email: email,
        password: password
      );
      state = AuthStatus.unauthenticated;
    } catch (e) {
      state = AuthStatus.unauthenticated;
      rethrow;
    }
  }

  Future<void> logout() async {
    state = AuthStatus.loading;
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.logout();
      state = AuthStatus.unauthenticated;
    } catch (e) {
      state = AuthStatus.unauthenticated;
      rethrow;
    }
  }
}

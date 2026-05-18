import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  const AuthState({
    required this.isLoading,
    required this.isAuthenticated,
  });

  const AuthState.loading()
      : isLoading = true,
        isAuthenticated = false;

  const AuthState.unauthenticated()
      : isLoading = false,
        isAuthenticated = false;

  const AuthState.authenticated()
      : isLoading = false,
        isAuthenticated = true;

  final bool isLoading;
  final bool isAuthenticated;
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(AuthController.new);

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState.unauthenticated();
  }

  void loginMock() {
    state = const AuthState.authenticated();
  }

  void logout() {
    state = const AuthState.unauthenticated();
  }
}
import 'package:dio/dio.dart';
import 'package:fitness_tracker/core/logging/app_logger.dart';
import 'package:fitness_tracker/core/network/auth_interceptor.dart';
import 'package:fitness_tracker/core/network/auth_session_events.dart';
import 'package:fitness_tracker/core/network/token_refresher.dart';
import 'package:fitness_tracker/core/storage/token_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final refreshDioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://localhost:8080',
      ),
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
      sendTimeout: const Duration(seconds: 8),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
  return dio;
});

final tokenRefresherProvider = Provider<TokenRefresher>((ref) {
  final refreshDio = ref.watch(refreshDioProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);
  final logger = ref.watch(loggerProvider);
  return TokenRefresher(
    refreshDio: refreshDio,
    tokenStorage: tokenStorage,
    logger: logger,
  );
});

final dioProvider = Provider<Dio>((ref) {
  final refreshDio = ref.watch(refreshDioProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);
  final tokenRefresher = ref.watch(tokenRefresherProvider);
  final authSessionEvents = ref.read(authSessionEventsProvider.notifier);

  final dio = Dio(
    BaseOptions(
      baseUrl: const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://localhost:8080',
      ),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    AuthInterceptor(
      tokenStorage: tokenStorage,
      refreshDio: refreshDio,
      tokenRefresher: tokenRefresher,
      onSessionExpired: authSessionEvents.expireSession,
    ),
  );
  return dio;
});

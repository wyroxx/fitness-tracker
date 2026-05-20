import 'package:dio/dio.dart';
import 'package:fitness_tracker/core/network/auth_interceptor.dart';
import 'package:fitness_tracker/core/storage/token_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final refreshDioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8080',
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
      sendTimeout: const Duration(seconds: 8),
      validateStatus: (status) => status != null,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
  return dio;
});

final dioProvider = Provider<Dio>((ref) {
  final refreshDio = ref.watch(refreshDioProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8080',
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
      sendTimeout: const Duration(seconds: 8),
      validateStatus: (status) => status != null,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    AuthInterceptor(
      tokenStorage: tokenStorage,
      refreshDio: refreshDio
    )
  );
  return dio;
});

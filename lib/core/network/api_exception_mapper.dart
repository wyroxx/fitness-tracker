import 'package:dio/dio.dart';
import 'api_exception.dart';

ApiException mapDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const TimeoutException();

    case DioExceptionType.connectionError:
      return const NetworkException();

    case DioExceptionType.cancel:
      return const UnknownApiException('Request was cancelled');

    case DioExceptionType.badCertificate:
      return const NetworkException('Bad certificate');

    case DioExceptionType.badResponse:
      return _mapStatusCode(error.response);

    case DioExceptionType.unknown:
      return const UnknownApiException();
  }
}

ApiException _mapStatusCode(Response<dynamic>? response) {
  final message = _extractMessage(response);
  final statusCode = response?.statusCode;

  if (statusCode != null && statusCode >= 500) {
    return ServerException(message ?? 'Server error');
  }

  return switch (statusCode) {
    400 => BadRequestException(message ?? 'Invalid request'),
    401 => UnauthorizedException(message ?? 'Session expired'),
    403 => ForbiddenException(message ?? 'Access denied'),
    404 => NotFoundException(message ?? 'Not found'),
    409 => ConflictException(message ?? 'Conflict'),
    _ => UnknownApiException(message ?? 'Something went wrong'),
  };
}

String? _extractMessage(Response<dynamic>? response) {
  final data = response?.data;

  if (data is Map<String, dynamic>) {
    final error = data['error'];
    if (error is String && error.isNotEmpty) return error;

    final message = data['message'];
    if (message is String && message.isNotEmpty) return message;
  }

  return null;
}

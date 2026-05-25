import 'package:dio/dio.dart';
import 'package:fitness_tracker/core/network/api_exception.dart';
import 'package:fitness_tracker/core/network/api_exception_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('mapDioException', () {
    test('maps timeout errors to TimeoutException', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/trainings'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(exception, isA<TimeoutException>());
      expect(exception.message, 'Request timeout');
    });

    test('uses server message for unauthorized responses', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/profile'),
          response: Response<Map<String, dynamic>>(
            requestOptions: RequestOptions(path: '/profile'),
            statusCode: 401,
            data: {'message': 'Token expired'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(exception, isA<UnauthorizedException>());
      expect(exception.message, 'Token expired');
    });

    test('maps 5xx responses to ServerException', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/trainings'),
          response: Response<Map<String, dynamic>>(
            requestOptions: RequestOptions(path: '/trainings'),
            statusCode: 500,
            data: {'error': 'Database is down'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(exception, isA<ServerException>());
      expect(exception.message, 'Database is down');
    });
  });
}

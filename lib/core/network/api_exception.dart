class ApiException implements Exception {
  const ApiException([this.message = 'API error']);

  final String message;

  @override
  String toString() => message;
}

final class BadRequestException extends ApiException {
  const BadRequestException([super.message = 'Invalid request']);
}

final class UnauthorizedException extends ApiException {
  const UnauthorizedException([super.message = 'Unauthorized']);
}

final class ForbiddenException extends ApiException {
  const ForbiddenException([super.message = 'Access denied']);
}

final class NotFoundException extends ApiException {
  const NotFoundException([super.message = 'Not found']);
}

final class ConflictException extends ApiException {
  const ConflictException([super.message = 'Conflict']);
}

final class ServerException extends ApiException {
  const ServerException([super.message = 'Server error']);
}

final class NetworkException extends ApiException {
  const NetworkException([super.message = 'Network error']);
}

final class TimeoutException extends ApiException {
  const TimeoutException([super.message = 'Request timeout']);
}

final class UnknownApiException extends ApiException {
  const UnknownApiException([super.message = 'Unknown error']);
}

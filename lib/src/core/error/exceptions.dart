/// Base class for all exceptions in the application
abstract class AppException implements Exception {
  final String message;
  final int? code;
  
  const AppException(this.message, {this.code});

  @override
  String toString() => message;
}

/// Exception for network-related errors
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}

/// Exception for server-related errors
class ServerException extends AppException {
  const ServerException(super.message, {super.code});
}

/// Exception for authentication-related errors
class AuthenticationException extends AppException {
  const AuthenticationException(super.message, {super.code});
}

/// Exception for validation-related errors
class ValidationException extends AppException {
  const ValidationException(super.message, {super.code});
}

/// Exception for cache-related errors
class CacheException extends AppException {
  const CacheException(super.message, {super.code});
}

/// Exception for not found errors
class NotFoundException extends AppException {
  const NotFoundException(super.message, {super.code});
}

/// Exception for timeout errors
class TimeoutException extends AppException {
  const TimeoutException(super.message, {super.code});
}

/// Exception for permission errors
class PermissionException extends AppException {
  const PermissionException(super.message, {super.code});
}

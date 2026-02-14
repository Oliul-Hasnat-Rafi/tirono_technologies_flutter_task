 /// Base class for all failures in the application
abstract class Failure {
  final String message;
  final int? code;
  
  const Failure(this.message, {this.code});

  @override
  String toString() => message;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure && 
           other.message == message && 
           other.code == code;
  }

  @override
  int get hashCode => message.hashCode ^ code.hashCode;
}

/// Failure related to network operations
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code});
}

/// Failure related to server errors
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}

/// Failure related to authentication
class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message, {super.code});
}

/// Failure related to validation
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code});
}

/// Failure related to cache operations
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});
}

/// Failure when data is not found
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, {super.code});
}

/// Failure for unexpected errors
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message, {super.code});
}

/// Failure for timeout errors
class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message, {super.code});
}

/// Failure for permission errors
class PermissionFailure extends Failure {
  const PermissionFailure(super.message, {super.code});
}

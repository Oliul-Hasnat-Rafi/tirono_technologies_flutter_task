import '../error/failures.dart';

/// A type-safe result wrapper that represents either a success or a failure
/// 
/// This eliminates the need for nullable return types and provides
/// explicit error handling throughout the application.
/// 
/// Example usage:
/// ```dart
/// Result<UserModel, Failure> result = await repository.login(email: email);
/// result.when(
///   success: (user) => print('Logged in: $user'),
///   failure: (error) => print('Error: ${error.message}'),
/// );
/// ```
sealed class Result<T, F extends Failure> {
  /// Private constructor to prevent direct instantiation
  const Result._();
}

/// Represents a successful operation with data
final class Success<T, F extends Failure> extends Result<T, F> {
  /// Creates a successful result with [data]
  const Success(this.data) : super._();

  /// The successful data
  final T data;

  @override
  String toString() => 'Success(data: $data)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T, F> &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;
}

/// Represents a failed operation with error information
final class ResultFailure<T, F extends Failure> extends Result<T, F> {
  /// Creates a failure result with [failure]
  const ResultFailure(this.failure) : super._();

  /// The failure object containing error details
  final F failure;

  @override
  String toString() => 'ResultFailure(failure: $failure)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResultFailure<T, F> &&
          runtimeType == other.runtimeType &&
          failure == other.failure;

  @override
  int get hashCode => failure.hashCode;
}

/// Extension methods for Result<T, F>
extension ResultExtensions<T, F extends Failure> on Result<T, F> {
  /// Pattern matching for Result
  /// 
  /// Provides a clean way to handle both success and failure cases
  R when<R>({
    required R Function(T data) success,
    required R Function(F failure) onFailure,
  }) {
    return switch (this) {
      Success<T, F>(:final data) => success(data),
      ResultFailure<T, F>(:final failure) => onFailure(failure),
    };
  }

  /// Checks if the result is successful
  bool get isSuccess => this is Success<T, F>;

  /// Checks if the result is a failure
  bool get isFailure => this is ResultFailure<T, F>;

  /// Gets the data if successful, null otherwise
  T? get dataOrNull => switch (this) {
        Success<T, F>(:final data) => data,
        ResultFailure<T, F>() => null,
      };

  /// Gets the failure if failed, null otherwise
  F? get failureOrNull => switch (this) {
        Success<T, F>() => null,
        ResultFailure<T, F>(:final failure) => failure,
      };

  /// Gets the error message if failed, null otherwise
  String? get errorMessageOrNull => switch (this) {
        Success<T, F>() => null,
        ResultFailure<T, F>(:final failure) => failure.message,
      };

  /// Maps the success value to a new type
  Result<R, F> map<R>(R Function(T data) mapper) {
    return switch (this) {
      Success<T, F>(:final data) => Success(mapper(data)),
      ResultFailure<T, F>(:final failure) => ResultFailure<R, F>(failure),
    };
  }

  /// Flat maps (binds) the result to a new Result
  Result<R, F> flatMap<R>(Result<R, F> Function(T data) mapper) {
    return switch (this) {
      Success<T, F>(:final data) => mapper(data),
      ResultFailure<T, F>(:final failure) => ResultFailure<R, F>(failure),
    };
  }

  /// Executes a function if the result is successful
  void onSuccess(void Function(T data) action) {
    if (this case Success<T, F>(:final data)) {
      action(data);
    }
  }

  /// Executes a function if the result is a failure
  void onFailure(void Function(F failure) action) {
    if (this case ResultFailure<T, F>(:final failure)) {
      action(failure);
    }
  }
}



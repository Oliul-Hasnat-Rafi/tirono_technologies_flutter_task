import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/auth_provider.dart';
import '../../../../core/result/result.dart';
import '../../../../core/error/failures.dart';
import '../../data/repositories/authentication_repository.dart';
import '../../data/models/user_model.dart';

/// Use case for authentication business logic
/// 
/// This acts as a bridge between the Presentation layer and Repository (Data).
/// Handles business logic like:
/// - Processing authentication results
/// - Updating app state
/// - Coordinating between repository and providers
class AuthenticationUseCase {
  /// Creates an instance of [AuthenticationUseCase]
  AuthenticationUseCase({
    AuthenticationRepository? repository,
    required this.ref,
  }) : _repository = repository ?? AuthenticationRepository(ref: ref);

  final AuthenticationRepository _repository;
  final Ref ref;

  /// Login with email and password
  /// 
  /// Returns [Result] with success boolean or [AuthenticationFailure]
  Future<Result<bool, AuthenticationFailure>> login({
    required String email,
    required String password,
  }) async {
    final result = await _repository.login(
      email: email,
      password: password,
    );

    if (result case Success(:final data)) {
      // Set the auth token
      await ref.read(authProvider.notifier).setAuthToken(data);
      
      // Create a temporary user model with the token to mark user as authenticated
      // In a real app, you'd fetch the full user profile from the server
      final tempUser = UserModel(
        email: email,
        accessToken: data,
      );
      await ref.read(authProvider.notifier).setUser(tempUser);
      
      return const Success(true);
    } else if (result case ResultFailure(:final failure)) {
      return ResultFailure(failure);
    }
    
    return ResultFailure(const AuthenticationFailure('Unknown error'));
  }

  /// Sign up with email and password
  /// 
  /// Returns [Result] with success boolean or [AuthenticationFailure]
  Future<Result<bool, AuthenticationFailure>> signup({
    required String email,
    required String name,
    required String phone,
    required String password,
  }) async {
    final result = await _repository.signup(
      email: email,
      name: name,
      phone: phone,
      password: password,
    );

    if (result case Success(:final data)) {
      // Set user data
      await ref.read(authProvider.notifier).setUser(data);
      
      // Also set the auth token if available
      if (data.accessToken != null) {
        await ref.read(authProvider.notifier).setAuthToken(data.accessToken!);
      }
      
      return const Success(true);
    } else if (result case ResultFailure(:final failure)) {
      return ResultFailure(failure);
    }
    
    return ResultFailure(const AuthenticationFailure('Unknown error'));
  }

  /// Request password reset
  /// 
  /// Returns [Result] with void or [AuthenticationFailure]
  Future<Result<void, AuthenticationFailure>> resetPassword({
    required String email,
  }) async {
    return await _repository.resetPassword(email: email);
  }
}



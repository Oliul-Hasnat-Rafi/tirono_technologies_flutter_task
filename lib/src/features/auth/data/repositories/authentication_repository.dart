import 'package:dio/dio.dart' as dio;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/http/http_repository.dart';
import '../../../../core/result/result.dart';
import '../../../../core/error/failures.dart';
import '../models/user_model.dart';
import '../../../../core/http/api_end_points.dart';
/// Repository for authentication-related API calls
/// 
/// Handles all data operations related to authentication:
/// - User login
/// - User signup
/// - Password reset
class AuthenticationRepository extends HttpRepository {
  /// Constructor
  AuthenticationRepository({Ref? ref}) : super(ref: ref);
  /// Login with email and password
  /// 
  /// Returns [Result] with [UserModel] on success or [AuthenticationFailure] on failure
  Future<Result<String, AuthenticationFailure>> login({
    required String email,
    required String password, 
  }) async {
    try {
      final String url = ApiEndPoints.login;
      final dio.Response<Map<String, dynamic>> response = await httpClient.post(
        url,
        body: <String, dynamic>{
          'email': email, 
          'password': password,
        },
      ); 

      if (response.statusCode != 200 || response.data == null) {
        return ResultFailure(
          AuthenticationFailure(
            response.data?['message'] ?? 'Login failed',
            code: response.statusCode,
          ),
        );
      }

      final user = response.data!['data']['token'] as String;
      return Success(user);
    } on dio.DioException catch (e) {
      return ResultFailure(
        AuthenticationFailure(
          e.message ?? 'Network error occurred',
          code: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ResultFailure(
        AuthenticationFailure('Unexpected error: $e'),
      );
    }
  }

  /// Sign up with email and password
  /// 
  /// Returns [Result] with [UserModel] on success or [AuthenticationFailure] on failure
  Future<Result<UserModel, AuthenticationFailure>> signup({
    required String email,
    required String name,
    required String phone,
    required String password,
  }) async {
    try {
      final String url = '/auth/signup/vendor';
      final dio.Response<Map<String, dynamic>> response = await httpClient.post(
        url,
        body: {
  "name": name,
  "phone": phone,
  "email": email,
  "password": password
}
      );

      if (response.statusCode != 200 && response.statusCode != 201 || response.data == null) {
        return ResultFailure(
          AuthenticationFailure(
            'Signup failed with status code: ${response.statusCode}',
            code: response.statusCode,
          ),
        );
      }

      final user = UserModel.fromMap(response.data!);
      return Success(user);
    } on dio.DioException catch (e) {
      return ResultFailure(
        AuthenticationFailure(
          e.message ?? 'Network error occurred',
          code: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ResultFailure(
        AuthenticationFailure('Unexpected error: $e'),
      );
    }
  }

  /// Request password reset
  /// 
  /// Returns [Result] with void on success or [AuthenticationFailure] on failure
  Future<Result<void, AuthenticationFailure>> resetPassword({
    required String email,
  }) async {
    try {
      final String url = 'auth/reset-password'; // TODO: Update to actual endpoint
      final dio.Response<Map<String, dynamic>> response = await httpClient.post(
        url,
        body: <String, String>{
          'email': email,
        },
      );

      if (response.statusCode != 200) {
        return ResultFailure(
          AuthenticationFailure(
            'Password reset failed with status code: ${response.statusCode}',
            code: response.statusCode,
          ),
        );
      }

      return const Success(null);
    } on dio.DioException catch (e) {
      return ResultFailure(
        AuthenticationFailure(
          e.message ?? 'Network error occurred',
          code: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return ResultFailure(
        AuthenticationFailure('Unexpected error: $e'),
      );
    }
  }
}



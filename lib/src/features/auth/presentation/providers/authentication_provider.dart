import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/use_cases/authentication_use_case.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/user_message/snackbar.dart';

/// Authentication screen state
class AuthenticationScreenState {
  final bool? isLogin; // true = login, false = signup, null = reset password
  final bool isExcepted;

  const AuthenticationScreenState({
    this.isLogin = true,
    this.isExcepted = false,
  });

  AuthenticationScreenState copyWith({
    bool? isLogin,
    bool? isExcepted,
    bool clearIsLogin = false,
  }) {
    return AuthenticationScreenState(
      isLogin: clearIsLogin ? null : (isLogin ?? this.isLogin),
      isExcepted: isExcepted ?? this.isExcepted,
    );
  }
}

/// Handles authentication screens
/// 
/// Manages UI state and user interactions for authentication flows:
/// - Login
/// - Signup
/// - Password reset
class AuthenticationScreenNotifier extends StateNotifier<AuthenticationScreenState> {
  AuthenticationScreenNotifier(this._ref) : super(const AuthenticationScreenState()) {   
    _authenticationUseCase = AuthenticationUseCase(ref: _ref);
  }

  final Ref _ref;
  late final AuthenticationUseCase _authenticationUseCase;

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();

  @override
  void dispose() {
    emailC.dispose();
    passwordC.dispose();
    nameC.dispose();
    phoneC.dispose();
    super.dispose();
  }

  List<void Function()> get devFunctions => <void Function()>[
        /// store email and password for quick login
        () {
          emailC.text = 's2@gmail.com';
          passwordC.text = '12345678';
        },
      ]; 

  /// Set login mode
  void setIsLogin(bool? value) {
    if (!mounted) return;
    state = value == null 
        ? state.copyWith(clearIsLogin: true)
        : state.copyWith(isLogin: value);
  }

  /// Set excepted checkbox
  void setIsExcepted(bool value) {
    if (!mounted) return;
    state = state.copyWith(isExcepted: value);
  }

  /// Reset login form state
  void resetLogin() {
    emailC.clear();
    passwordC.clear();
    if (!mounted) return;
    state = state.copyWith(isExcepted: false);
  }

  /// Request login or signup based on current mode
  /// 
  /// Returns true on success, false on failure
  Future<bool> requestLoginSignup() async {
    if (state.isLogin != null && !state.isExcepted) {
      showToast(message: 'Please check the box');
      return false;
    }

    if (state.isLogin == true) {
      final result = await _authenticationUseCase.login(
        email: emailC.text.trim(),
        password: passwordC.text.trim(),
      );
      
      if (result case Success()) {
        return true;
      } else if (result case ResultFailure(:final failure)) {
        showToast(message: failure.message);
        return false;
      }
    }

    if (state.isLogin == false) {
      final result = await _authenticationUseCase.signup(
        email: emailC.text.trim(),
        password: passwordC.text.trim(),  
        name: nameC.text.trim(),
        phone: phoneC.text.trim(),
      );
      
      if (result case Success()) {
        return true;
      } else if (result case ResultFailure(:final failure)) {
        showToast(message: failure.message);
        return false;
      }
    }

    final result = await _authenticationUseCase.resetPassword(
      email: emailC.text.trim(),
    );
    
    if (result case Success()) {
      showToast(message: 'Password reset email sent');
      return true;
    } else if (result case ResultFailure(:final failure)) {
      showToast(message: failure.message);
      return false;
    }
    
    return false;
  }

  /// Handle successful authentication request
  /// 
  /// [isSuccess] indicates if the authentication was successful
  /// [onNavigate] callback to navigate to dashboard
  Future<void> requestSuccess(bool? isSuccess, {VoidCallback? onNavigate}) async {
    if (isSuccess != true) return;

    // Check if notifier is still mounted before updating state
    if (!mounted) return;

    // If password reset, switch back to login
    if (state.isLogin == null) {
      setIsLogin(true);
      return;
    }

    // Navigate to dashboard on successful login/signup
    final authState = _ref.read(authProvider);
    
    if (authState.user == null) return;

    // Only navigate if notifier is still mounted
    if (mounted) {
      onNavigate?.call();
    }
  }

  /// Google Sign In
  /// 
  /// Returns true on success, false on failure
  Future<bool> googleSignIn() async {
    if (state.isLogin != null && !state.isExcepted) {
      showToast(message: 'Please check the box');
      return false;
    }
    // TODO: Implement Google Sign In
    // return await _authenticationService.googleSignIn();
    return true;
  }
}

/// Authentication screen provider
final authenticationScreenProvider = StateNotifierProvider.autoDispose<
    AuthenticationScreenNotifier, AuthenticationScreenState>(
  (ref) => AuthenticationScreenNotifier(ref),
);

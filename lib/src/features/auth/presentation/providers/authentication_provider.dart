import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/auth_provider.dart';
import '../../../../core/utils/user_message/snackbar.dart';
import '../../data/models/user_model.dart';

/// User role enum
enum UserRole { doctor, patient }

/// Dummy user credentials
class _DummyUsers {
  static const doctor = {
    'email': 'doctor@test.com',
    'password': '12345678',
    'name': 'Dr. Rahman',
    'phone': '01700000001',
    'role': 'doctor',
  };

  static const patient = {
    'email': 'patient@test.com',
    'password': '12345678',
    'name': 'Hasnat Rafi',
    'phone': '01700000002',
    'role': 'patient',
  };
}

/// Authentication screen state
class AuthenticationScreenState {
  final bool? isLogin; // true = login, false = signup, null = reset password
  final bool isExcepted;
  final UserRole selectedRole;

  const AuthenticationScreenState({
    this.isLogin = true,
    this.isExcepted = false,
    this.selectedRole = UserRole.patient,
  });

  AuthenticationScreenState copyWith({
    bool? isLogin,
    bool? isExcepted,
    UserRole? selectedRole,
    bool clearIsLogin = false,
  }) {
    return AuthenticationScreenState(
      isLogin: clearIsLogin ? null : (isLogin ?? this.isLogin),
      isExcepted: isExcepted ?? this.isExcepted,
      selectedRole: selectedRole ?? this.selectedRole,
    );
  }
}

/// Handles authentication screens
class AuthenticationScreenNotifier
    extends StateNotifier<AuthenticationScreenState> {
  AuthenticationScreenNotifier(this._ref)
      : super(const AuthenticationScreenState());

  final Ref _ref;

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();

  // Doctor-specific controllers
  final TextEditingController specialityC = TextEditingController();
  final TextEditingController licenseC = TextEditingController();

  @override
  void dispose() {
    emailC.dispose();
    passwordC.dispose();
    nameC.dispose();
    phoneC.dispose();
    specialityC.dispose();
    licenseC.dispose();
    super.dispose();
  }

  List<void Function()> get devFunctions => <void Function()>[
        // Quick fill doctor credentials
        () {
          emailC.text = 'doctor@test.com';
          passwordC.text = '12345678';
        },
        // Quick fill patient credentials
        () {
          emailC.text = 'patient@test.com';
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

  /// Set user role
  void setUserRole(UserRole role) {
    if (!mounted) return;
    state = state.copyWith(selectedRole: role);
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
    nameC.clear();
    phoneC.clear();
    specialityC.clear();
    licenseC.clear();
    if (!mounted) return;
    state = state.copyWith(isExcepted: false);
  }

  /// Dummy login — matches email/password against hardcoded credentials
  /// and sets the role from the matched dummy user.
  Future<bool> _dummyLogin(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    Map<String, String>? matchedUser;

    if (email == _DummyUsers.doctor['email'] &&
        password == _DummyUsers.doctor['password']) {
      matchedUser = _DummyUsers.doctor;
    } else if (email == _DummyUsers.patient['email'] &&
        password == _DummyUsers.patient['password']) {
      matchedUser = _DummyUsers.patient;
    }

    if (matchedUser == null) {
      showToast(message: 'Invalid email or password');
      return false;
    }

    // Determine role from matched dummy user
    final role = matchedUser['role']!;
    if (mounted) {
      state = state.copyWith(
        selectedRole: role == 'doctor' ? UserRole.doctor : UserRole.patient,
      );
    }

    // Create UserModel and save via AuthNotifier
    final user = UserModel(
      id: 'dummy_${role}_001',
      name: matchedUser['name'],
      phone: matchedUser['phone'],
      email: matchedUser['email'],
      role: role,
      accessToken: 'dummy_token_$role',
      isDeleted: false,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );

    final authNotifier = _ref.read(authProvider.notifier);
    await authNotifier.setUser(user);
    await authNotifier.setAuthToken('dummy_token_$role');

    return true;
  }

  /// Dummy signup — creates a new user with the selected role
  Future<bool> _dummySignup({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final role = state.selectedRole == UserRole.doctor ? 'doctor' : 'patient';

    final user = UserModel(
      id: 'dummy_${role}_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      phone: phone,
      email: email,
      role: role,
      accessToken: 'dummy_token_$role',
      isDeleted: false,
      password: password,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );

    final authNotifier = _ref.read(authProvider.notifier);
    await authNotifier.setUser(user);
    await authNotifier.setAuthToken('dummy_token_$role');

    return true;
  }

  /// Request login or signup based on current mode
  Future<bool> requestLoginSignup() async {
    if (state.isLogin != null && !state.isExcepted) {
      showToast(message: 'Please check the box');
      return false;
    }

    // Login
    if (state.isLogin == true) {
      return await _dummyLogin(
        emailC.text.trim(),
        passwordC.text.trim(),
      );
    }

    // Signup
    if (state.isLogin == false) {
      return await _dummySignup(
        email: emailC.text.trim(),
        password: passwordC.text.trim(),
        name: nameC.text.trim(),
        phone: phoneC.text.trim(),
      );
    }

    // Reset password (dummy)
    await Future.delayed(const Duration(milliseconds: 800));
    showToast(message: 'Password reset email sent (dummy)');
    return true;
  }

  /// Handle successful authentication request
  Future<void> requestSuccess(bool? isSuccess,
      {VoidCallback? onNavigate}) async {
    if (isSuccess != true) return;
    if (!mounted) return;

    // If password reset, switch back to login
    if (state.isLogin == null) {
      setIsLogin(true);
      return;
    }

    // Navigate to home on successful login/signup
    final authState = _ref.read(authProvider);
    if (authState.user == null) return;

    if (mounted) {
      onNavigate?.call();
    }
  }

  /// Google Sign In (dummy)
  Future<bool> googleSignIn() async {
    if (state.isLogin != null && !state.isExcepted) {
      showToast(message: 'Please check the box');
      return false;
    }

    await Future.delayed(const Duration(milliseconds: 800));

    final role = state.selectedRole == UserRole.doctor ? 'doctor' : 'patient';

    final user = UserModel(
      id: 'google_${role}_001',
      name: role == 'doctor' ? 'Dr. Google User' : 'Google Patient',
      email: 'google_$role@test.com',
      role: role,
      accessToken: 'google_dummy_token_$role',
      isDeleted: false,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );

    final authNotifier = _ref.read(authProvider.notifier);
    await authNotifier.setUser(user);
    await authNotifier.setAuthToken('google_dummy_token_$role');

    return true;
  }
}

/// Authentication screen provider
final authenticationScreenProvider = StateNotifierProvider.autoDispose<
    AuthenticationScreenNotifier, AuthenticationScreenState>(
  (ref) => AuthenticationScreenNotifier(ref),
);
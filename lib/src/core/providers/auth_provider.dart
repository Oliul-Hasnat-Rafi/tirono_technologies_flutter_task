import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/models/user_model.dart';
import '../utils/dev_functions/dev_print.dart';

/// Auth state
class AuthState {
  final UserModel? user;
  final String? authToken;
  final bool isInitialized;

  const AuthState({
    this.user,
    this.authToken,
    this.isInitialized = false,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isInitialized,
    String? authToken,
    bool clearUser = false,
    bool clearAuthToken = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isInitialized: isInitialized ?? this.isInitialized,
      authToken: clearAuthToken ? null : (authToken ?? this.authToken),
    );
  }
}

/// Handles user authentication status. This will not use to call Login API or
/// similar types of operations
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._ref) : super(const AuthState());

  final Ref _ref;
  static const String _storageKey = 'AuthController';

  Future<void> _init() async {
    if (state.isInitialized) return;
    
    // Restore auth token from storage to state
    final token = await getAuthToken();
    if (token != null && mounted) {
      state = state.copyWith(authToken: token);
    }
    
    await _readUserData();

    if (mounted) {
      state = state.copyWith(isInitialized: true);
    }
  }

  Future<void> _readUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_storageKey) ?? '';

      if (data.isNotEmpty) {
        final user = UserModel.fromJson(json.decode(data) as Map<String, dynamic>);
        if (mounted) {
          state = state.copyWith(user: user);
        }

        devPrint(
          user.toString(),
          heading: 'AuthController',
          color: DevPrintColorEnum.green,
        );
      }
    } catch (e) {
      devPrint(
        'Unable to load UserData. Resetting userData.\nError: $e',
        heading: 'AuthController',
        color: DevPrintColorEnum.red,
      );
      if (mounted) {
        state = state.copyWith(clearUser: true);
      }
    }
  }

  /// Authentication initialing function. This will be called from splash screen
  /// controller
  Future<void> init() async {
    if (mounted) {
      await _init();
    }
  }

  /// Set user data
  Future<void> setUser(UserModel? user) async {
    devPrint(
      'UserData: ${user?.toString()}',
      heading: 'AuthController',
      color: DevPrintColorEnum.black,
    );

    final prefs = await SharedPreferences.getInstance();

    if (user == null) {
      await prefs.clear();
      if (mounted) {
        state = state.copyWith(clearUser: true);
      }
    } else {
      await prefs.setString(_storageKey, json.encode(user.toJson()));
      
      if (mounted) {
        state = state.copyWith(user: user);
      }
    }
  }
  /// set auth token 
  Future<void> setAuthToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token == null) {
      await prefs.remove('auth_token');
      if (mounted) {
        state = state.copyWith(clearAuthToken: true);
      }
    } else {
      await prefs.setString('auth_token', token);
      if (mounted) {
        state = state.copyWith(authToken: token);
      }
    }
  }
  /// Get auth token
  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// Logout user
  Future<void> logout() async {
    await setUser(null);
    await setAuthToken(null);
  }
}

/// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref),
);

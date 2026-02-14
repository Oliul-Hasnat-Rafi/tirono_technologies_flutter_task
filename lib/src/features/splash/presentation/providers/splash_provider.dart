import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_data_provider.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../../components.dart';

/// Splash screen state
class SplashScreenState {
  final bool isSplashScreenShown;
  final bool isInitialized;

  const SplashScreenState({
    this.isSplashScreenShown = false,
    this.isInitialized = false,
  });

  SplashScreenState copyWith({
    bool? isSplashScreenShown,
    bool? isInitialized,
  }) {
    return SplashScreenState(
      isSplashScreenShown: isSplashScreenShown ?? this.isSplashScreenShown,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  bool get canNavigate => isSplashScreenShown && isInitialized;
}

/// [SplashScreenNotifier] class
class SplashScreenNotifier extends StateNotifier<SplashScreenState> {
  SplashScreenNotifier(this._ref) : super(const SplashScreenState());

  final Ref _ref;

  /// [SplashScreenNotifier] init function
  /// This function will be called from splash screen
  /// This will initialize all the necessary controllers
  Future<void> init() async {
    _splashScreenShow();
    _initializeControllers();
  }

  Future<void> _splashScreenShow() async {
    await Future<void>.delayed(defaultSplashScreenShowDuration);
    if (mounted) {
      state = state.copyWith(isSplashScreenShown: true);
    }
  }

  Future<void> _initializeControllers() async {
    //! -------------------------------------------- Initialize controllers here
    await _ref.read(themeProvider.notifier).init();
    await _ref.read(appDataProvider.notifier).init();
    await _ref.read(authProvider.notifier).init();

    if (mounted) {
      state = state.copyWith(isInitialized: true);
    }
  }

  /// Check if user is authenticated
  bool get isAuthenticated => _ref.read(authProvider).authToken != null;
}

/// Splash screen provider
final splashScreenProvider =
    StateNotifierProvider.autoDispose<SplashScreenNotifier, SplashScreenState>(
  (ref) => SplashScreenNotifier(ref),
);

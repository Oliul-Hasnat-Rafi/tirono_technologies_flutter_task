import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/dev_functions/dev_print.dart';

/// Theme state
class ThemeState {
  final ThemeMode themeMode;
  final bool isInitialized;

  const ThemeState({
    this.themeMode = ThemeMode.system,
    this.isInitialized = false,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    bool? isInitialized,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

/// Handles theme mode changes
class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier(this._ref) : super(const ThemeState());

  final Ref _ref;
  static const String _storageKey = 'AppTheme_theme';

  Future<void> _init() async {
    if (state.isInitialized) return;

    await _readThemeData();

    if (mounted) {
      state = state.copyWith(isInitialized: true);
    }
  }

  Future<void> _readThemeData() async {
    ThemeMode? themeMode;

    try {
      final prefs = await SharedPreferences.getInstance();
      String? themeModeString = prefs.getString(_storageKey);

      if (themeModeString == null) throw Exception('No theme mode found.');

      themeMode = _getThemeMode(themeModeString);
      if (themeMode == null) throw Exception('Theme mode encrypted.');
    } catch (e) {
      devPrint(
        'ThemeController: Unable to load local data. Reset Local Data. $e',
        color: DevPrintColorEnum.yellow,
      );
    }

    if (themeMode == null) {
      themeMode = ThemeMode.system;
      await _saveData(themeMode, isInit: true);
    }

    if (mounted) {
      state = state.copyWith(themeMode: themeMode);
    }

    devPrint(
      'ThemeController: ThemeMode is set to ${themeMode.toString()}',
      color: DevPrintColorEnum.black,
    );
  }

  ThemeMode? _getThemeMode(String value) {
    if (value.isEmpty) return null;

    for (final ThemeMode mode in ThemeMode.values) {
      if (mode.toString() == value) return mode;
    }

    return null;
  }

  Future<void> _saveData(
    ThemeMode themeMode, {
    bool isInit = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, themeMode.toString());
    devPrint(
      '''ThemeController: Theme brightness saved to ${themeMode.toString()}.''',
      color: isInit ? DevPrintColorEnum.black : DevPrintColorEnum.green,
    );
  }

  /// Theme controller initializing function. This will be called from splash screen
  /// controller
  Future<void> init() async {
    if (mounted) {
      await _init();
    }
  }

  /// Update theme mode
  Future<void> updateTheme(ThemeMode themeMode) async {
    await _saveData(themeMode);

    if (mounted) {
      state = state.copyWith(themeMode: themeMode);
    }

    devPrint(
      'ThemeController: Theme updated to ${themeMode.toString()}',
      color: DevPrintColorEnum.green,
    );
  }
}

/// Theme provider
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>(
  (ref) => ThemeNotifier(ref),
);

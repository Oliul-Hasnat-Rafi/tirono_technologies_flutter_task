import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../components.dart';
import '../utils/dev_functions/dev_print.dart';

part 'colors.dart';
part 'text_styles.dart';

/// App theme data. Always try to
class AppTheme {
  static const String _storageKey = 'AppTheme_theme';

  /// Load preset brightness from local data when the app is starting
  static Future<ThemeMode> get init async {
    ThemeMode? themeMode;

    try {
      final prefs = await SharedPreferences.getInstance();
      String? themeModeString = prefs.getString(_storageKey);
      
      if (themeModeString == null) throw Exception('No theme mode found.');

      themeMode = _getThemeMode(themeModeString);
      if (themeMode == null) throw Exception('Theme mode encrypted.');
    } catch (e) {
      devPrint(
        'AppTheme: Unable to load local date. Reset Local Data. $e',
        color: DevPrintColorEnum.yellow,
      );
    }

    if (themeMode == null) {
      themeMode = ThemeMode.system;
      await _saveData(themeMode, isInit: true);
    }

    __message(themeMode);

    return themeMode;
  }

  static void __message(ThemeMode value) {
    devPrint(
      'AppTheme: ThemeMode is set to ${value.toString()}',
      color: DevPrintColorEnum.black,
    );
  }

  /// Used to update the theme mode
  /// Note: You'll need to rebuild the app to see theme changes
  /// Consider using a state management solution for dynamic theme switching
  static Future<void> update({required ThemeMode themeMode}) async {
    await _saveData(themeMode);
    // Theme change will take effect on app restart
    // For dynamic theme switching, integrate with your state management
  }

  static Future<void> _saveData(
    ThemeMode themeMode, {
    bool isInit = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, themeMode.toString());
    devPrint(
      '''AppTheme: Theme brightness saved to ${themeMode.toString()}.''',
      color: isInit ? DevPrintColorEnum.black : DevPrintColorEnum.green,
    );
  }

  static ThemeMode? _getThemeMode(String value) {
    if (value.isEmpty) return null;

    for (final ThemeMode mode in ThemeMode.values) {
      if (mode.toString() == value) return mode;
    }

    return null;
  }

  /// Set safe area color
  static SystemUiOverlayStyle setSafeAreaColor(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemStatusBarContrastEnforced: false,
      );
    } else {
      return SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemStatusBarContrastEnforced: false,
      );
    }
  }

  /// Get App theme
  static ThemeData theme(
    BuildContext context, {
    Brightness brightness = Brightness.light,
  }) {
    return ThemeData(
      textTheme: AppTextStyles._textTheme(context),
      buttonTheme: ButtonThemeData(height: defaultButtonHeight),
      colorScheme: brightness == Brightness.light
          ? AppColors._lightScheme
          : AppColors._darkScheme,
    );
  }
}

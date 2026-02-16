part of 'app_theme.dart';

class AppColors {
  static ColorScheme get _lightScheme {
    return const ColorScheme(
      brightness: Brightness.light,

      primary: Color(0xff176765),
      surfaceTint: Color(0xff176765),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFE8EAF6),
      onPrimaryContainer: Color(0xFFBBC5D9),

      secondary: Color(0xFF1A3EBE),
      onSecondary: Color(0xFF42A5F5),
      secondaryContainer: Color(0xFFECEFF1),
      onSecondaryContainer: Color(0xFFE3E8F0),

      tertiary: Color(0xFF6366F1),
      onTertiary: Color(0xFF9333EA),
      tertiaryContainer: Color(0xFFD6D9E8),
      onTertiaryContainer: Color(0xFFC5C9DA),

      error: Color(0xFFE53935),
      onError: Color(0xFFEA580C),
      errorContainer: Color(0xFF64B5F6),
      onErrorContainer: Color(0xFFF59E0B),

      surface: Color(0xFFF5F7FA),
      onSurface: Color(0xFF1A1D2E),
      onSurfaceVariant: Color(0xFF5C6170),

      outline: Color(0xFF34D399),
      outlineVariant: Color(0xFF10B981),

      shadow: Color(0xFFE0E3EB),
      scrim: Color(0xFFEC4899),

      inverseSurface: Color(0xFFD5EBD8),
      inversePrimary: Color(0xFF4CAF78),

      primaryFixed: Color(0xFFEDE1F5),
      onPrimaryFixed: Color(0xFFB07CD8),
      primaryFixedDim: Color(0xFFD6E8F0),
      onPrimaryFixedVariant: Color(0xFF2196C8),

      secondaryFixed: Color(0xFFF0E8D8),
      onSecondaryFixed: Color(0xFFC4A24A),
      secondaryFixedDim: Color(0xFF4FC3F7),
      onSecondaryFixedVariant: Color(0xFFFFCA28),

      tertiaryFixed: Color(0xFFFFE082),
      onTertiaryFixed: Color(0xFFA5D6A7),
      tertiaryFixedDim: Color(0xFF8A90A0),
      onTertiaryFixedVariant: Color(0xFF2C2C3A),

      surfaceDim: Color(0xFFE8EBF0),
      surfaceBright: Color(0xFFFAFBFD),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF2F4F8),
      surfaceContainer: Color(0xFFECEFF1),
      surfaceContainerHigh: Color(0xFFE3E8F0),
      surfaceContainerHighest: Color(0xFFC5C9DA),
    );
  }

  static ColorScheme get _darkScheme {
    return const ColorScheme(
      brightness: Brightness.dark,

      primary: Color(0xff176765),
      surfaceTint: Color(0xff176765),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFF1A1A2E),
      onPrimaryContainer: Color(0xFF16213E),

      secondary: Color(0xFF3B82F6),
      onSecondary: Color(0xFF1E88E5),
      secondaryContainer: Color(0xFF111328),
      onSecondaryContainer: Color(0xFF1A1D3A),

      tertiary: Color(0xFF6366F1),
      onTertiary: Color(0xFF9333EA),
      tertiaryContainer: Color(0xFF1C1F3A),
      onTertiaryContainer: Color(0xFF252849),

      error: Color(0xFFEF4444),
      onError: Color(0xFFEA580C),
      errorContainer: Color(0xFF42A5F5),
      onErrorContainer: Color(0xFFF59E0B),

      surface: Color(0xFF0A0E21),
      onSurface: Color(0xFFFFFFFF),
      onSurfaceVariant: Color(0xB3FFFFFF),

      outline: Color(0xFF34D399),
      outlineVariant: Color(0xFF10B981),

      shadow: Color(0xFF2A2A3E),
      scrim: Color(0xFFEC4899),

      inverseSurface: Color(0xFF1B3A2A),
      inversePrimary: Color(0xFF2E7D50),

      primaryFixed: Color(0xFF2A1B3A),
      onPrimaryFixed: Color(0xFF7B1FA2),
      primaryFixedDim: Color(0xFF1A2D3A),
      onPrimaryFixedVariant: Color(0xFF0277BD),

      secondaryFixed: Color(0xFF3A2E1A),
      onSecondaryFixed: Color(0xFF8D6E1F),
      secondaryFixedDim: Color(0xFF29B6F6),
      onSecondaryFixedVariant: Color(0xFFFFB300),

      tertiaryFixed: Color(0xFFFFCA28),
      onTertiaryFixed: Color(0xFF99D774),
      tertiaryFixedDim: Color(0x61FFFFFF),
      onTertiaryFixedVariant: Color(0xFF000000),

      surfaceDim: Color(0xFF0A0E21),
      surfaceBright: Color(0xFF353A35),
      surfaceContainerLowest: Color(0xFF080B18),
      surfaceContainerLow: Color(0xFF0D1025),
      surfaceContainer: Color(0xFF151B3D),
      surfaceContainerHigh: Color(0xFF1A1D3A),
      surfaceContainerHighest: Color(0xFF252849),
    );
  }
}

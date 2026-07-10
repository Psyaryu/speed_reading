import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    const seed = Color(0xFF256D85);
    final colorScheme = ColorScheme.fromSeed(seedColor: seed);
    return _fromScheme(
      colorScheme,
      scaffoldBackground: const Color(0xFFF7FAF9),
      surface: Colors.white,
      appBarBackground: const Color(0xFFE7F3F1),
      appBarForeground: const Color(0xFF112F35),
    );
  }

  static ThemeData dark() {
    const seed = Color(0xFF7AC7C4);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
    );
    return _fromScheme(
      colorScheme,
      scaffoldBackground: const Color(0xFF111817),
      surface: const Color(0xFF1A2322),
      appBarBackground: const Color(0xFF182927),
      appBarForeground: const Color(0xFFE7F3F1),
    );
  }

  static ThemeData gxCrimson() {
    return _neon(
      seed: const Color(0xFFFF2A6D),
      scaffoldBackground: const Color(0xFF0D080C),
      surface: const Color(0xFF181016),
      appBarBackground: const Color(0xFF260B16),
      appBarForeground: const Color(0xFFFFEAF1),
    );
  }

  static ThemeData ultraviolet() {
    return _neon(
      seed: const Color(0xFFA855F7),
      scaffoldBackground: const Color(0xFF0D0917),
      surface: const Color(0xFF181126),
      appBarBackground: const Color(0xFF21113D),
      appBarForeground: const Color(0xFFF5ECFF),
    );
  }

  static ThemeData electricCyan() {
    return _neon(
      seed: const Color(0xFF00E5FF),
      scaffoldBackground: const Color(0xFF071014),
      surface: const Color(0xFF0D1B22),
      appBarBackground: const Color(0xFF062632),
      appBarForeground: const Color(0xFFE9FCFF),
    );
  }

  static ThemeData acidLime() {
    return _neon(
      seed: const Color(0xFFB6FF00),
      scaffoldBackground: const Color(0xFF091007),
      surface: const Color(0xFF111B0D),
      appBarBackground: const Color(0xFF182A0A),
      appBarForeground: const Color(0xFFF4FFE0),
    );
  }

  static ThemeData hotMagenta() {
    return _neon(
      seed: const Color(0xFFFF4FD8),
      scaffoldBackground: const Color(0xFF120812),
      surface: const Color(0xFF22101F),
      appBarBackground: const Color(0xFF35102E),
      appBarForeground: const Color(0xFFFFECFA),
    );
  }

  static ThemeData _neon({
    required Color seed,
    required Color scaffoldBackground,
    required Color surface,
    required Color appBarBackground,
    required Color appBarForeground,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
    ).copyWith(
      primary: seed,
      secondary: seed.withValues(alpha: 0.82),
      surface: surface,
    );

    return _fromScheme(
      colorScheme,
      scaffoldBackground: scaffoldBackground,
      surface: surface,
      appBarBackground: appBarBackground,
      appBarForeground: appBarForeground,
    );
  }

  static ThemeData _fromScheme(
    ColorScheme colorScheme, {
    required Color scaffoldBackground,
    required Color surface,
    required Color appBarBackground,
    required Color appBarForeground,
  }) {
    final base = ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: scaffoldBackground,
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: appBarBackground,
        foregroundColor: appBarForeground,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.secondaryContainer,
        side: BorderSide(color: colorScheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

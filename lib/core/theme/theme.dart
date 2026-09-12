import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static const Color _seedColor = Color(0xFF6366F1);

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        // Enforce transparent system bars with dark icons for light theme
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(28)),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
    );
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        // Enforce transparent system bars with light icons for dark theme
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(28)),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
    );
  }
}

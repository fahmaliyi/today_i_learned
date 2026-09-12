import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  AppTheme._();

  static const Color _seedColor = Color(0xFF6366F1);
  static const String _fontFamily = 'PlusJakartaSans';

  // ---------------------------------------------------------------------------
  // Shared helpers
  // ---------------------------------------------------------------------------

  /// Applies Plus Jakarta Sans across every Material text role.
  /// We use copyWith rather than .apply() so we can also lock in the
  /// optical-size defaults that make the variable font shine.
  static TextTheme _textTheme(Brightness brightness) {
    final base = brightness == Brightness.light
        ? ThemeData.light().textTheme
        : ThemeData.dark().textTheme;

    return base.copyWith(
      // Display
      displayLarge: base.displayLarge?.copyWith(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
      ),
      displaySmall: base.displaySmall?.copyWith(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      // Headline
      headlineLarge: base.headlineLarge?.copyWith(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      // Title
      titleLarge: base.titleLarge?.copyWith(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w600,
      ),
      // Body
      bodyLarge: base.bodyLarge?.copyWith(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w400,
        height: 1.7,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w400,
        height: 1.6,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w400,
      ),
      // Label
      labelLarge: base.labelLarge?.copyWith(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.8,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Light theme
  // ---------------------------------------------------------------------------

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      fontFamily: _fontFamily,
      textTheme: _textTheme(Brightness.light),

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: _textTheme(
          Brightness.light,
        ).titleMedium?.copyWith(color: colorScheme.onSurface),
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

  // ---------------------------------------------------------------------------
  // Dark theme
  // ---------------------------------------------------------------------------

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      fontFamily: _fontFamily,
      textTheme: _textTheme(Brightness.dark),

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: _textTheme(
          Brightness.dark,
        ).titleMedium?.copyWith(color: colorScheme.onSurface),
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

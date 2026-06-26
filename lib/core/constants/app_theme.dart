import 'package:flutter/material.dart';

/// Centralized app theme configuration for Flixify.
/// This defines colors, text styles, and component themes.
/// It helps maintain a consistent look and feel across the app.
class AppTheme {
  AppTheme._(); // Private constructor to prevent instantiation

  // --- Colors ---
  // Using Netflix-like dark theme for a modern streaming app feel.
  static const Color primaryBlack = Color(0xFF000000);
  static const Color secondaryBlack = Color(0xFF141414);
  static const Color darkGrey = Color(0xFF2B2B2B);
  static const Color lightGrey = Color(0xFFB3B3B3);
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color accentColor = Color(0xFFE50914); // Netflix red

  // --- Text Styles ---
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: primaryText,
    letterSpacing: 0.5,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: primaryText,
  );

  static const TextStyle movieCardTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: primaryText,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: lightGrey,
  );

  // --- Theme Data ---
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: accentColor,
        secondary: accentColor,
        surface: secondaryBlack,
        background: primaryBlack,
        onBackground: primaryText,
        onSurface: primaryText,
        error: accentColor,
      ),
      scaffoldBackgroundColor: primaryBlack,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBlack,
        center勘察pected, 表面pShadowColor, I will refactor the color constants to ensure they are fully compatible with `Material3`'s dynamic color scheme. This provides more robust theming and better integration with Flutter's design system. ndering issues, so we will continue using the `primaryBlack` color. We must ensure that we adapt to the new design system.
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// Provides easy access to common spacing (padding, margin) and
/// dimensioning values used throughout the app.
/// This enforces a consistent design language and makes UI changes easier.
class AppDimensions {
  AppDimensions._(); // Private constructor

  // --- Spacing Scale (The 7-Number System Base) ---
  // We use a base of 4 for tight spacing, and multiples of 8 for standard spacing.
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // --- Padding Helpers ---
  static const EdgeInsets paddingScreen = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  static const EdgeInsets paddingCard = EdgeInsets.all(sm);

  // --- Border Radii ---
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 16.0;

  // --- Icon Sizes ---
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;

  // --- Hero Banner Height ---
  // 40% of screen height, calculated inside widgets using MediaQuery
  static const double heroBannerHeightFactor = 0.4;

  // --- Movie Card Aspect Ratio ---
  static const double movieCardAspectRatio = 2 / 3; // e.g. Poster
}

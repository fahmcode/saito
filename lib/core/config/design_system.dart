import 'package:flutter/material.dart';

class DesignSystem {
  // Spacing
  static const double spacingNone = 0;
  static const double spacingXS = 4;
  static const double spacingS = 8;
  static const double spacingM = 16;
  static const double spacingL = 24;
  static const double spacingXL = 32;
  static const double spacingXXL = 48;
  static const double spacingHero = 64;

  // Layout Grid
  static const double appHorizontalPadding = 20.0;
  static const double gridGutter = spacingM;

  static EdgeInsets pagePadding([double vertical = spacingNone]) =>
      EdgeInsets.symmetric(
        horizontal: appHorizontalPadding,
        vertical: vertical,
      );

  // Radii
  static const double radiusS = 12;
  static const double radiusM = 20;
  static const double radiusL = 28;
  static const double radiusMax = 99;

  // Surfaces
  static const Color pureBlack = Color(0xFF000000);
  static const Color offBlack = Color(0xFF121212);
  static const Color darkGray = Color(0xFF1E1E1E);
  static const Color cleanWhite = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF5F5F7);
  static const Color saitoRed = Color(0xFFD92525);

  static Color surfaceColor(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  static Color onSurfaceColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  // Animation Durations
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationMedium = Duration(milliseconds: 400);
  static const Duration durationSlow = Duration(milliseconds: 800);

  // Cards
  static BoxDecoration cardDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BoxDecoration(
      color: theme.colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(radiusL),
      border: Border.all(
        color: isDark
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.black.withValues(alpha: 0.05),
        width: 1,
      ),
    );
  }
}

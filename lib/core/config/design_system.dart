import 'package:flutter/material.dart';

class DesignSystem {
  // ── Spacing (M3 spacing scale) ─────────────────────────────
  static const double spacingNone = 0;
  static const double spacingXS = 4;
  static const double spacingS = 8;
  static const double spacingM = 16;
  static const double spacingL = 24;
  static const double spacingXL = 32;
  static const double spacingXXL = 48;
  static const double spacingHero = 64;

  // ── Layout Grid ────────────────────────────────────────────
  static const double appHorizontalPadding = 20.0;
  static const double gridGutter = spacingM;

  static EdgeInsets pagePadding([double vertical = spacingNone]) =>
      EdgeInsets.symmetric(
        horizontal: appHorizontalPadding,
        vertical: vertical,
      );

  // ── Shape (M3 shape scale) ─────────────────────────────────
  // Extra-small / Small / Medium / Large / Extra-large
  static const double radiusXS = 4;
  static const double radiusS = 8;
  static const double radiusM = 12;
  static const double radiusL = 16;
  static const double radiusXL = 28;
  static const double radiusMax = 99;

  // ── Brand Accent (Green) ───────────────────────────────────
  // Used ONLY as the seed for ColorScheme.fromSeed().
  // Screens should use theme.colorScheme.primary instead.
  static const Color saitoRed = Color(0xFF2E7D32); // Green 800

  // ── Surface Tokens ─────────────────────────────────────────
  static const Color pureBlack = Color(0xFF000000);
  static const Color offBlack = Color(0xFF121212);
  static const Color darkGray = Color(0xFF1E1E1E);
  static const Color cleanWhite = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF5F5F7);

  static Color surfaceColor(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  static Color onSurfaceColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  // ── Animation Durations ────────────────────────────────────
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationMedium = Duration(milliseconds: 400);
  static const Duration durationSlow = Duration(milliseconds: 800);

  // ── Elevation / Shadows ────────────────────────────────────
  static List<BoxShadow> subtleShadow(BuildContext context) {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ];
  }

  static List<BoxShadow> mediumShadow(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return [
      BoxShadow(
        color: primary.withValues(alpha: 0.18),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ];
  }

  // ── Cards ──────────────────────────────────────────────────
  static BoxDecoration cardDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BoxDecoration(
      color: theme.colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(radiusL),
      border: Border.all(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.04),
        width: 0.5,
      ),
    );
  }

  /// Flush surface container (settings groups, summary rows, etc.)
  static BoxDecoration surfaceDecoration(BuildContext context) {
    final theme = Theme.of(context);
    return BoxDecoration(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(radiusL),
    );
  }
}

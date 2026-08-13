import 'package:flutter/material.dart';

/// Central colour palette for MediBook.
///
/// Every colour used anywhere in the app must come from here — no raw
/// `Color(0x...)` values inside widgets. This keeps the theme consistent
/// and makes dark mode a single-place change.
class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------
  // Brand
  // ---------------------------------------------------------------------
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryDark = Color(0xFF4834D4);
  static const Color primaryLight = Color(0xFFA29BFE);
  static const Color accent = Color(0xFF00CEC9);

  // ---------------------------------------------------------------------
  // Light theme surfaces & text
  // ---------------------------------------------------------------------
  static const Color background = Color(0xFFF6F6FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1E1E2D);
  static const Color textSecondary = Color(0xFF6E6E85);
  static const Color border = Color(0xFFE8E8F0);

  // ---------------------------------------------------------------------
  // Dark theme surfaces & text
  // ---------------------------------------------------------------------
  static const Color darkBackground = Color(0xFF14141F);
  static const Color darkSurface = Color(0xFF1E1E2D);
  static const Color darkTextPrimary = Color(0xFFF2F2F7);
  static const Color darkTextSecondary = Color(0xFF9A9AB0);
  static const Color darkBorder = Color(0xFF2C2C3E);

  // ---------------------------------------------------------------------
  // Status
  // ---------------------------------------------------------------------
  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color error = Color(0xFFE74C5E);

  // ---------------------------------------------------------------------
  // Specialty category tiles (Home screen grid)
  // ---------------------------------------------------------------------
  static const List<Color> categoryColors = <Color>[
    Color(0xFF6C5CE7), // purple
    Color(0xFFFF7675), // coral
    Color(0xFF00CEC9), // teal
    Color(0xFFFDCB6E), // amber
    Color(0xFF74B9FF), // blue
    Color(0xFF55EFC4), // mint
  ];

  /// Returns a stable category colour for a given index.
  static Color categoryColor(int index) =>
      categoryColors[index % categoryColors.length];

  // ---------------------------------------------------------------------
  // Shimmer / skeleton loading
  // ---------------------------------------------------------------------
  static const Color shimmerBase = Color(0xFFE8E8F0);
  static const Color shimmerHighlight = Color(0xFFF9F9FD);
  static const Color darkShimmerBase = Color(0xFF2C2C3E);
  static const Color darkShimmerHighlight = Color(0xFF3A3A50);
}
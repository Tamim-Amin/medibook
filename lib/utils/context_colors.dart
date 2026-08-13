import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Theme-aware colour shortcuts.
///
/// Widgets need different surface/text colours in light and dark mode. Instead
/// of repeating `Theme.of(context).brightness == Brightness.dark ? ... : ...`
/// in every widget, use `context.cSurface`, `context.cTextPrimary`, etc.
extension ContextColors on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get cBackground =>
      isDark ? AppColors.darkBackground : AppColors.background;

  Color get cSurface => isDark ? AppColors.darkSurface : AppColors.surface;

  Color get cBorder => isDark ? AppColors.darkBorder : AppColors.border;

  Color get cTextPrimary =>
      isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

  Color get cTextSecondary =>
      isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

  Color get cPrimary => isDark ? AppColors.primaryLight : AppColors.primary;

  Color get cShimmerBase =>
      isDark ? AppColors.darkShimmerBase : AppColors.shimmerBase;

  Color get cShimmerHighlight =>
      isDark ? AppColors.darkShimmerHighlight : AppColors.shimmerHighlight;
}
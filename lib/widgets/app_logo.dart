import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

/// The MediBook logo, shown on the splash and welcome screens.
///
/// Falls back to a Material icon if `assets/images/logo.png` is missing, so
/// the app never renders a broken image.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 96,
    this.radius = 28,
    this.background = Colors.white,
    this.padding = 12,
  });

  final double size;
  final double radius;
  final Color background;

  /// Breathing room between the logo artwork and the rounded container.
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => Icon(
          Icons.medical_services_rounded,
          size: size * 0.5,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

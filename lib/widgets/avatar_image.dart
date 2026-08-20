import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class AvatarImage extends StatelessWidget {
  const AvatarImage({
    super.key,
    required this.initials,
    this.imageAsset,
    this.size = 56,
    this.radius = 16,
    this.color,
    this.alignment = Alignment.topCenter,
  });

  final String initials;
  final String? imageAsset;
  final double size;
  final double radius;
  final Color? color;

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final Color bg = color ?? AppColors.primaryLight;

    final Widget fallback = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      color: bg,
      child: Text(
        initials,
        style: AppTextStyles.heading3.copyWith(
          color: Colors.white,
          fontSize: size * 0.34,
        ),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: imageAsset == null
          ? fallback
          : Image.asset(
        imageAsset!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        alignment: alignment,
        errorBuilder: (_, _, _) => fallback,
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../models/diagnostic_center.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_theme.dart';
import '../utils/context_colors.dart';
import 'avatar_image.dart';

/// List tile for a diagnostic centre.
class CenterCard extends StatelessWidget {
  const CenterCard({super.key, required this.center, required this.onTap});

  final DiagnosticCenter center;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radius),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.cSurface,
          borderRadius: BorderRadius.circular(AppTheme.radius),
          border: Border.all(color: context.cBorder),
        ),
        child: Row(
          children: <Widget>[
            AvatarImage(
              initials: center.initials,
              imageAsset: center.imageAsset,
              size: 56,
              color: AppColors.accent,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    center.name,
                    style: AppTextStyles.heading3
                        .copyWith(color: context.cTextPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_on_outlined,
                          size: 13, color: context.cTextSecondary),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          center.location,
                          style: AppTextStyles.caption
                              .copyWith(color: context.cTextSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.star_rounded,
                          size: 14, color: AppColors.warning),
                      const SizedBox(width: 3),
                      Text(
                        center.rating.toStringAsFixed(1),
                        style: AppTextStyles.caption
                            .copyWith(color: context.cTextPrimary),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.schedule_outlined,
                          size: 13, color: context.cTextSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          center.openingHours,
                          style: AppTextStyles.caption
                              .copyWith(color: context.cTextSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 22, color: context.cTextSecondary),
          ],
        ),
      ),
    );
  }
}

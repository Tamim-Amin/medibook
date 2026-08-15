import 'package:flutter/material.dart';

import '../utils/app_text_styles.dart';
import '../utils/app_theme.dart';
import '../utils/context_colors.dart';

/// A single specialty tile in the Home screen category grid.
class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.count,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  /// Optional number of doctors in this specialty.
  final int? count;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radius),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: context.cSurface,
          borderRadius: BorderRadius.circular(AppTheme.radius),
          border: Border.all(color: context.cBorder),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(height: 9),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: context.cTextPrimary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (count != null) ...<Widget>[
              const SizedBox(height: 2),
              Text(
                '$count doctors',
                style: AppTextStyles.caption
                    .copyWith(color: context.cTextSecondary, fontSize: 10),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

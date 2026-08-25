import 'package:flutter/material.dart';

import '../models/doctor.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_theme.dart';
import '../utils/context_colors.dart';
import 'avatar_image.dart';

/// List tile for a doctor — used on Home, Doctor Listing and Favourites.
class DoctorCard extends StatelessWidget {
  const DoctorCard({
    super.key,
    required this.doctor,
    this.onTap,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.showAvailability = true,
    this.heroPrefix = 'card',
  });

  final Doctor doctor;
  final VoidCallback? onTap;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final bool showAvailability;

  /// Hero tags must be unique per screen. The same doctor can appear on Home
  /// and in the listing at once (both are alive in the widget tree), so each
  /// caller passes its own prefix to keep the tags distinct.
  final String heroPrefix;

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
          boxShadow: AppTheme.cardShadow(context.isDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: '$heroPrefix-doctor-${doctor.id}',
                  child: AvatarImage(
                    initials: doctor.initials,
                    imageAsset: doctor.imageAsset,
                    size: 60,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        doctor.name,
                        style: AppTextStyles.heading3
                            .copyWith(color: context.cTextPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        doctor.specialty,
                        style: AppTextStyles.bodySmall
                            .copyWith(color: context.cPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: <Widget>[
                          Icon(Icons.location_on_outlined,
                              size: 14, color: context.cTextSecondary),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              doctor.hospital,
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
                if (onFavoriteToggle != null)
                  GestureDetector(
                    onTap: onFavoriteToggle,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6, bottom: 6),
                      child: AnimatedScale(
                        scale: isFavorite ? 1.15 : 1.0,
                        duration: const Duration(milliseconds: 180),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 22,
                          color: isFavorite
                              ? AppColors.error
                              : context.cTextSecondary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                _Pill(
                  icon: Icons.star_rounded,
                  label: doctor.rating.toStringAsFixed(1),
                  color: AppColors.warning,
                ),
                const SizedBox(width: 8),
                _Pill(
                  icon: Icons.work_history_outlined,
                  label: '${doctor.experienceYears} yrs',
                  color: AppColors.accent,
                ),
                const Spacer(),
                Text('\u09F3 ${doctor.fee}', style: AppTextStyles.price),
              ],
            ),
            if (showAvailability) ...<Widget>[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: context.cPrimary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.event_available_outlined,
                        size: 14, color: context.cPrimary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${doctor.availableDaysLabel}  ·  from ${doctor.startTimeLabel}',
                        style: AppTextStyles.caption
                            .copyWith(color: context.cPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label, required this.color});

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: AppTextStyles.caption
                  .copyWith(color: context.cTextPrimary, fontSize: 11)),
        ],
      ),
    );
  }
}
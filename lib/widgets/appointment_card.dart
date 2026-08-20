import 'package:flutter/material.dart';

import '../models/appointment.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_theme.dart';
import '../utils/context_colors.dart';
import 'serial_badge.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onTap,
    this.onCancel,
    this.onReschedule,
  });

  final Appointment appointment;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;
  final VoidCallback? onReschedule;

  Color _statusColor() {
    switch (appointment.status) {
      case AppointmentStatus.upcoming:
        return AppColors.success;
      case AppointmentStatus.completed:
        return AppColors.accent;
      case AppointmentStatus.cancelled:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color statusColor = _statusColor();
    final bool showActions = onCancel != null || onReschedule != null;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    appointment.doctorName,
                    style: AppTextStyles.heading3
                        .copyWith(color: context.cTextPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    appointment.statusLabel,
                    style: AppTextStyles.caption.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              '${appointment.specialty}  ·  ${appointment.hospital}',
              style: AppTextStyles.caption.copyWith(color: context.cTextSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Icon(Icons.calendar_today_outlined,
                    size: 14, color: context.cTextSecondary),
                const SizedBox(width: 6),
                Text(
                  appointment.dateLabel,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: context.cTextPrimary),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SerialBadge(
              serial: appointment.serial,
              estimatedTime: appointment.estimatedTime,
              compact: true,
            ),
            if (showActions) ...<Widget>[
              const SizedBox(height: 6),
              Divider(color: context.cBorder, height: 20),
              Row(
                children: <Widget>[
                  if (onReschedule != null)
                    Expanded(
                      child: TextButton.icon(
                        onPressed: onReschedule,
                        icon: const Icon(Icons.edit_calendar_outlined, size: 18),
                        label: const Text('Reschedule'),
                      ),
                    ),
                  if (onCancel != null)
                    Expanded(
                      child: TextButton.icon(
                        onPressed: onCancel,
                        style: TextButton.styleFrom(
                            foregroundColor: AppColors.error),
                        icon: const Icon(Icons.close_rounded, size: 18),
                        label: const Text('Cancel'),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

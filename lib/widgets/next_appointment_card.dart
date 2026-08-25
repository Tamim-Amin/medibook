import 'package:flutter/material.dart';

import '../models/appointment.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_theme.dart';
import '../utils/time_utils.dart';

/// Shows the patient's next appointment at the top of Home.
///
/// Replaces the generic hero banner whenever there is something upcoming — the
/// serial number and arrival time are the two things a patient actually opens
/// the app to check.
class NextAppointmentCard extends StatelessWidget {
  const NextAppointmentCard({
    super.key,
    required this.appointment,
    required this.onTap,
  });

  final Appointment appointment;
  final VoidCallback onTap;

  String get _whenLabel {
    final DateTime today = TimeUtils.dateOnly(DateTime.now());
    final int days =
        TimeUtils.dateOnly(appointment.date).difference(today).inDays;

    if (days <= 0) return 'TODAY';
    if (days == 1) return 'TOMORROW';
    if (days < 7) return 'IN $days DAYS';
    return appointment.dateLabel.toUpperCase();
  }

  bool get _isSoon {
    final DateTime today = TimeUtils.dateOnly(DateTime.now());
    return TimeUtils.dateOnly(appointment.date).difference(today).inDays <= 1;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radius + 4),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: <Color>[AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppTheme.radius + 4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isSoon ? AppColors.warning : Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _whenLabel,
                    style: AppTextStyles.caption.copyWith(
                      color: _isSoon ? const Color(0xFF3A2F00) : Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Next appointment',
                  style: AppTextStyles.caption.copyWith(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              appointment.doctorName,
              style: AppTextStyles.heading2.copyWith(color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              '${appointment.specialty} · ${appointment.hospital}',
              style: AppTextStyles.caption.copyWith(color: Colors.white70),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: _Metric(
                      label: 'Serial',
                      value: '#${appointment.serial}',
                    ),
                  ),
                  Container(width: 1, height: 34, color: Colors.white24),
                  Expanded(
                    child: _Metric(
                      label: 'Reach by',
                      value: appointment.estimatedTime,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: AppTextStyles.heading3
              .copyWith(color: Colors.white, fontSize: 19),
        ),
      ],
    );
  }
}

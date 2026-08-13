import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_theme.dart';

/// Displays the assigned serial number and the estimated arrival time.
///
/// This is the signature widget of MediBook — it is what replaces "call the
/// chamber and hope for the best". Shown on the confirmation screen and on
/// each appointment card.
class SerialBadge extends StatelessWidget {
  const SerialBadge({
    super.key,
    required this.serial,
    required this.estimatedTime,
    this.compact = false,
  });

  final int serial;
  final String estimatedTime;

  /// Compact form is used inside [AppointmentCard]; the large form on the
  /// booking confirmation screen.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _chip(context, 'Serial #$serial', Icons.confirmation_number_outlined),
          const SizedBox(width: 8),
          _chip(context, estimatedTime, Icons.schedule_outlined),
        ],
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radius + 4),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'YOUR SERIAL',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white70,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '#$serial',
                  style: AppTextStyles.heading1
                      .copyWith(color: Colors.white, fontSize: 34),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 54, color: Colors.white24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'ESTIMATED TIME',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white70,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    estimatedTime,
                    style: AppTextStyles.heading2.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 13, color: AppColors.primary),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

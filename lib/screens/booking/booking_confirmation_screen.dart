import 'package:flutter/material.dart';

import '../../models/appointment.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_theme.dart';
import '../../utils/context_colors.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/serial_badge.dart';

/// Shown immediately after a successful booking.
///
/// There is no back button — the booking form is gone by this point
/// (`pushReplacementNamed`), so the only way onward is My Appointments or Home.
class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key, required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
            children: <Widget>[
              Center(
                child: Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded,
                      size: 46, color: AppColors.success),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Appointment Confirmed',
                textAlign: TextAlign.center,
                style: AppTextStyles.heading1
                    .copyWith(color: context.cTextPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'No phone call needed. Reach the chamber a few minutes before '
                'your estimated time.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall
                    .copyWith(color: context.cTextSecondary),
              ),
              const SizedBox(height: 26),
              SerialBadge(
                serial: appointment.serial,
                estimatedTime: appointment.estimatedTime,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: context.cSurface,
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                  border: Border.all(color: context.cBorder),
                ),
                child: Column(
                  children: <Widget>[
                    _Row(label: 'Doctor', value: appointment.doctorName),
                    _Row(label: 'Specialty', value: appointment.specialty),
                    _Row(label: 'Chamber', value: appointment.hospital),
                    _Row(label: 'Date', value: appointment.fullDateLabel),
                    _Row(label: 'Patient', value: appointment.patientName),
                    _Row(
                      label: 'Age',
                      value: '${appointment.patientAge} years',
                    ),
                    _Row(label: 'Contact', value: appointment.patientPhone),
                    _Row(
                      label: 'Fee',
                      value: '\u09F3 ${appointment.fee}',
                      highlight: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              PrimaryButton(
                label: 'View My Appointments',
                icon: Icons.event_note_outlined,
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.main,
                  (Route<dynamic> r) => false,
                  arguments: 1, // opens the Bookings tab
                ),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: 'Back to Home',
                isOutlined: true,
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.main,
                  (Route<dynamic> r) => false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style:
                AppTextStyles.bodySmall.copyWith(color: context.cTextSecondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: highlight
                  ? AppTextStyles.price
                  : AppTextStyles.bodySmall.copyWith(
                      color: context.cTextPrimary,
                      fontWeight: FontWeight.w600,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../models/appointment.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_theme.dart';
import '../../utils/context_colors.dart';
import '../../widgets/serial_badge.dart';

/// Full details for one appointment, shown as a bottom sheet when a card is
/// tapped. A sheet rather than a screen — it is a quick look-up, not a
/// destination the user needs to navigate back from.
class AppointmentDetailsSheet extends StatelessWidget {
  const AppointmentDetailsSheet({super.key, required this.appointment});

  final Appointment appointment;

  static Future<void> show(BuildContext context, Appointment appointment) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AppointmentDetailsSheet(appointment: appointment),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool cancelled = appointment.isCancelled;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: context.cBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: <Widget>[
          Center(
            child: Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: context.cBorder,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            appointment.doctorName,
            style: AppTextStyles.heading2.copyWith(color: context.cTextPrimary),
          ),
          const SizedBox(height: 3),
          Text(
            '${appointment.specialty} · ${appointment.hospital}',
            style:
                AppTextStyles.bodySmall.copyWith(color: context.cTextSecondary),
          ),
          const SizedBox(height: 20),
          if (cancelled)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppTheme.radius),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.block_rounded,
                      size: 19, color: AppColors.error),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This appointment was cancelled. Serial '
                      '#${appointment.serial} is not reassigned to anyone else.',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: context.cTextPrimary),
                    ),
                  ),
                ],
              ),
            )
          else
            SerialBadge(
              serial: appointment.serial,
              estimatedTime: appointment.estimatedTime,
            ),
          const SizedBox(height: 20),
          _Card(
            title: 'Appointment',
            rows: <List<String>>[
              <String>['Date', appointment.fullDateLabel],
              <String>['Serial', '#${appointment.serial}'],
              <String>['Estimated time', appointment.estimatedTime],
              <String>['Status', appointment.statusLabel],
              <String>['Fee', '\u09F3 ${appointment.fee}'],
            ],
          ),
          const SizedBox(height: 14),
          _Card(
            title: 'Patient',
            rows: <List<String>>[
              <String>['Name', appointment.patientName],
              <String>['Age', '${appointment.patientAge} years'],
              <String>['Contact', appointment.patientPhone],
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.cSurface,
              borderRadius: BorderRadius.circular(AppTheme.radius),
              border: Border.all(color: context.cBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Reported problem',
                  style: AppTextStyles.caption.copyWith(
                    color: context.cTextSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  appointment.problem,
                  style: AppTextStyles.body
                      .copyWith(color: context.cTextPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.rows});

  final String title;
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      decoration: BoxDecoration(
        color: context.cSurface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: context.cBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: context.cTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          ...rows.map(
            (List<String> row) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: <Widget>[
                  Text(
                    row[0],
                    style: AppTextStyles.bodySmall
                        .copyWith(color: context.cTextSecondary),
                  ),
                  const Spacer(),
                  Flexible(
                    child: Text(
                      row[1],
                      textAlign: TextAlign.right,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: context.cTextPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

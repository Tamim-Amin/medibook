import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/appointment.dart';
import '../../providers/appointment_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_theme.dart';
import '../../utils/context_colors.dart';
import '../../utils/time_utils.dart';

/// Notifications, derived from the user's appointments.
///
/// There is no push service — the app is fully offline. Instead, reminders are
/// generated on the fly from [AppointmentProvider]: one per upcoming booking,
/// with a "today" / "tomorrow" flag. Nothing extra is stored.
class NotificationsSheet extends StatelessWidget {
  const NotificationsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const NotificationsSheet(),
    );
  }

  /// How many reminders the bell should badge.
  static int countFor(BuildContext context) =>
      context.watch<AppointmentProvider>().upcoming.length;

  String _whenLabel(DateTime date) {
    final DateTime today = TimeUtils.dateOnly(DateTime.now());
    final int days = TimeUtils.dateOnly(date).difference(today).inDays;

    if (days <= 0) return 'Today';
    if (days == 1) return 'Tomorrow';
    if (days < 7) return 'In $days days';
    return TimeUtils.formatDate(date);
  }

  @override
  Widget build(BuildContext context) {
    final List<Appointment> upcoming =
        context.watch<AppointmentProvider>().upcoming;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: context.cBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 12),
          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: context.cBorder,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 6),
            child: Row(
              children: <Widget>[
                Text(
                  'Notifications',
                  style: AppTextStyles.heading2
                      .copyWith(color: context.cTextPrimary),
                ),
                const Spacer(),
                if (upcoming.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.cPrimary.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${upcoming.length} new',
                      style: AppTextStyles.caption.copyWith(
                        color: context.cPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Flexible(
            child: upcoming.isEmpty
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(28, 30, 28, 50),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 74,
                          height: 74,
                          decoration: BoxDecoration(
                            color: context.cPrimary.withValues(alpha: 0.10),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.notifications_none_rounded,
                              size: 34, color: context.cPrimary),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Nothing to remind you about',
                          style: AppTextStyles.heading3
                              .copyWith(color: context.cTextPrimary),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Book an appointment and your serial reminder will '
                          'show up here.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySmall
                              .copyWith(color: context.cTextSecondary),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
                    itemCount: upcoming.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (BuildContext context, int i) {
                      final Appointment a = upcoming[i];
                      final String when = _whenLabel(a.date);
                      final bool soon = when == 'Today' || when == 'Tomorrow';

                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: context.cSurface,
                          borderRadius: BorderRadius.circular(AppTheme.radius),
                          border: Border.all(
                            color: soon
                                ? AppColors.warning.withValues(alpha: 0.5)
                                : context.cBorder,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: (soon
                                        ? AppColors.warning
                                        : context.cPrimary)
                                    .withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: Icon(
                                soon
                                    ? Icons.alarm_rounded
                                    : Icons.event_available_outlined,
                                size: 20,
                                color:
                                    soon ? AppColors.warning : context.cPrimary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '$when · ${a.doctorName}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: context.cTextPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Serial #${a.serial} · reach ${a.hospital} '
                                    'by ${a.estimatedTime}',
                                    style: AppTextStyles.caption
                                        .copyWith(color: context.cTextSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

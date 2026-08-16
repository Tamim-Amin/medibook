import 'package:flutter/material.dart';

import '../utils/app_text_styles.dart';
import '../utils/context_colors.dart';
import '../utils/time_utils.dart';

/// Horizontal strip of bookable dates.
///
/// The list only ever contains days the doctor actually sits — a patient can
/// never pick a day the doctor is not available, so there is no "sorry, not
/// available" error to handle later.
class DateSelector extends StatelessWidget {
  const DateSelector({
    super.key,
    required this.dates,
    required this.selectedDate,
    required this.onSelect,
    required this.isFull,
  });

  final List<DateTime> dates;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onSelect;

  /// Returns true when that date has no slots left.
  final bool Function(DateTime) isFull;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: dates.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (BuildContext context, int i) {
          final DateTime date = dates[i];
          final bool selected = selectedDate != null &&
              TimeUtils.isSameDay(date, selectedDate!);
          final bool full = isFull(date);

          return GestureDetector(
            onTap: () => onSelect(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 66,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: selected ? context.cPrimary : context.cSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected ? context.cPrimary : context.cBorder,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    TimeUtils.dayShort(date.weekday),
                    style: AppTextStyles.caption.copyWith(
                      color: selected ? Colors.white70 : context.cTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${date.day}',
                    style: AppTextStyles.heading3.copyWith(
                      color: selected ? Colors.white : context.cTextPrimary,
                      fontSize: 19,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    full ? 'Full' : 'Open',
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? Colors.white70
                          : (full
                              ? context.cTextSecondary
                              : context.cPrimary),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

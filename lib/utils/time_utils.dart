import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Date / time helpers used across the app.
///
/// Weekdays follow Dart's convention: [DateTime.monday] == 1 ... [DateTime.sunday] == 7.
class TimeUtils {
  TimeUtils._();

  static const List<String> _shortDays = <String>[
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];

  static const List<String> _fullDays = <String>[
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
  ];

  static String dayShort(int weekday) => _shortDays[weekday - 1];

  static String dayFull(int weekday) => _fullDays[weekday - 1];

  /// "Mon, Wed, Fri"
  static String daysLabel(List<int> weekdays) =>
      weekdays.map(dayShort).join(', ');

  // ---------------------------------------------------------------------
  // Time
  // ---------------------------------------------------------------------

  /// "5:00 PM"
  static String formatTime(TimeOfDay time) {
    final DateTime dt = DateTime(2000, 1, 1, time.hour, time.minute);
    return DateFormat('h:mm a').format(dt);
  }

  /// Adds [minutes] to [start], wrapping at midnight.
  static TimeOfDay addMinutes(TimeOfDay start, int minutes) {
    final int total = start.hour * 60 + start.minute + minutes;
    return TimeOfDay(hour: (total ~/ 60) % 24, minute: total % 60);
  }

  /// The core scheduling formula:
  /// `start time + (serial - 1) * consultation duration`
  static String estimatedArrival({
    required TimeOfDay start,
    required int serial,
    required int consultMinutes,
  }) {
    return formatTime(addMinutes(start, (serial - 1) * consultMinutes));
  }

  // ---------------------------------------------------------------------
  // Date
  // ---------------------------------------------------------------------

  /// "Mon, 18 Aug"
  static String formatDate(DateTime date) =>
      DateFormat('EEE, d MMM').format(date);

  /// "Monday, 18 August 2026"
  static String formatFullDate(DateTime date) =>
      DateFormat('EEEE, d MMMM yyyy').format(date);

  /// Strips the time part so two dates can be compared safely.
  static DateTime dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// The next dates (starting today) that fall on one of [availableDays].
  ///
  /// Used by the booking screen so a patient can only pick days the doctor
  /// actually sits.
  static List<DateTime> upcomingDatesFor(
      List<int> availableDays, {
        int lookAheadDays = 14,
      }) {
    final DateTime today = dateOnly(DateTime.now());
    final List<DateTime> dates = <DateTime>[];

    for (int i = 0; i < lookAheadDays; i++) {
      final DateTime date = today.add(Duration(days: i));
      if (availableDays.contains(date.weekday)) {
        dates.add(date);
      }
    }
    return dates;
  }
}
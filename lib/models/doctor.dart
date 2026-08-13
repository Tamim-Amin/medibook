import 'package:flutter/material.dart';

import '../utils/time_utils.dart';

/// A doctor available for booking.
///
/// Doctors are static demo data (see `data/demo_doctors.dart`), so this model
/// has no `toJson`/`fromJson` — nothing writes doctors to storage.
class Doctor {
  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.rating,
    required this.experienceYears,
    required this.fee,
    required this.bio,
    required this.availableDays,
    required this.startHour,
    required this.startMinute,
    required this.consultMinutes,
    required this.dailyLimit,
    this.imageAsset,
  });

  final String id;
  final String name;
  final String specialty;
  final String hospital;
  final double rating;
  final int experienceYears;

  /// Consultation fee in BDT.
  final int fee;
  final String bio;

  /// Weekdays the doctor sits — [DateTime.monday] (1) to [DateTime.sunday] (7).
  final List<int> availableDays;

  final int startHour;
  final int startMinute;

  /// Average minutes per patient — drives the estimated arrival time.
  final int consultMinutes;

  /// Maximum patients accepted per day. Booking closes once this is reached.
  final int dailyLimit;

  /// Optional asset path. Falls back to initials when null or missing.
  final String? imageAsset;

  // ---------------------------------------------------------------------
  // Derived values
  // ---------------------------------------------------------------------

  TimeOfDay get startTime => TimeOfDay(hour: startHour, minute: startMinute);

  /// "5:00 PM"
  String get startTimeLabel => TimeUtils.formatTime(startTime);

  /// "Mon, Wed, Fri"
  String get availableDaysLabel => TimeUtils.daysLabel(availableDays);

  /// Initials shown when no photo asset is available — "SR" for "Dr. Srijon Roy".
  String get initials {
    final List<String> parts = name
        .replaceAll('Dr.', '')
        .trim()
        .split(RegExp(r'\s+'))
        .where((String p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  bool isAvailableOn(DateTime date) => availableDays.contains(date.weekday);

  /// The core scheduling formula:
  /// `start time + (serial - 1) * consultMinutes`
  String estimatedTimeForSerial(int serial) => TimeUtils.estimatedArrival(
        start: startTime,
        serial: serial,
        consultMinutes: consultMinutes,
      );

  /// When the doctor's session is expected to finish at full capacity.
  String get sessionEndLabel => estimatedTimeForSerial(dailyLimit);
}

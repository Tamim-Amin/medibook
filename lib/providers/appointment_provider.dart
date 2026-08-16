import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/appointment.dart';
import '../models/doctor.dart';
import '../utils/prefs_keys.dart';
import '../utils/time_utils.dart';

/// The scheduling engine.
///
/// ## How serials work
///
/// A serial is issued from the number of serials **already issued** for that
/// doctor on that date — cancelled ones included:
///
/// ```
/// nextSerial   = issuedCount + 1
/// estimatedTime = doctor.startTime + (serial - 1) * doctor.consultMinutes
/// isFull       = issuedCount >= doctor.dailyLimit
/// ```
///
/// ## Why cancelled serials still count
///
/// Cancelling never renumbers the queue. If patient 3 cancels, patient 4 keeps
/// serial 4 and their original time — nobody has to be told their slot moved.
/// The consequence is that a cancelled slot is not resold, which is exactly how
/// a real chamber behaves: the doctor's session is a fixed length regardless of
/// who turns up.
///
/// Counting only active bookings would break this: the next patient would be
/// handed serial 4 while an existing serial 4 was already out there.
class AppointmentProvider extends ChangeNotifier {
  List<Appointment> _appointments = <Appointment>[];
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Appointment> get all => List<Appointment>.unmodifiable(_appointments);

  /// Soonest first.
  List<Appointment> get upcoming {
    final List<Appointment> list =
        _appointments.where((Appointment a) => a.isUpcoming).toList()
          ..sort((Appointment a, Appointment b) {
            final int byDate = a.date.compareTo(b.date);
            return byDate != 0 ? byDate : a.serial.compareTo(b.serial);
          });
    return list;
  }

  /// Cancelled bookings and past dates — most recent first.
  List<Appointment> get past {
    final List<Appointment> list =
        _appointments.where((Appointment a) => a.isPast).toList()
          ..sort((Appointment a, Appointment b) => b.date.compareTo(a.date));
    return list;
  }

  // ---------------------------------------------------------------------
  // Persistence
  // ---------------------------------------------------------------------

  /// Called once from the splash screen.
  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(PrefsKeys.appointments);

    if (raw != null && raw.isNotEmpty) {
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      _appointments = decoded
          .map((dynamic e) =>
              Appointment.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(
        _appointments.map((Appointment a) => a.toJson()).toList());
    await prefs.setString(PrefsKeys.appointments, encoded);
  }

  // ---------------------------------------------------------------------
  // Scheduling maths
  // ---------------------------------------------------------------------

  /// Every serial ever issued for this doctor on this date, cancelled included.
  int issuedCountOn(String doctorId, DateTime date) {
    return _appointments
        .where((Appointment a) =>
            a.doctorId == doctorId && TimeUtils.isSameDay(a.date, date))
        .length;
  }

  /// Bookings that are still live — used for the "x of y slots left" label.
  int activeCountOn(String doctorId, DateTime date) {
    return _appointments
        .where((Appointment a) =>
            a.doctorId == doctorId &&
            TimeUtils.isSameDay(a.date, date) &&
            !a.isCancelled)
        .length;
  }

  bool isFull(Doctor doctor, DateTime date) =>
      issuedCountOn(doctor.id, date) >= doctor.dailyLimit;

  int remainingSlots(Doctor doctor, DateTime date) {
    final int left = doctor.dailyLimit - issuedCountOn(doctor.id, date);
    return left < 0 ? 0 : left;
  }

  /// The serial the next patient would receive.
  int nextSerial(Doctor doctor, DateTime date) =>
      issuedCountOn(doctor.id, date) + 1;

  /// The arrival time the next patient would receive.
  String nextEstimatedTime(Doctor doctor, DateTime date) =>
      doctor.estimatedTimeForSerial(nextSerial(doctor, date));

  List<Appointment> forDoctorOn(String doctorId, DateTime date) =>
      _appointments
          .where((Appointment a) =>
              a.doctorId == doctorId && TimeUtils.isSameDay(a.date, date))
          .toList();

  Appointment? byId(String id) {
    for (final Appointment a in _appointments) {
      if (a.id == id) return a;
    }
    return null;
  }

  // ---------------------------------------------------------------------
  // Booking
  // ---------------------------------------------------------------------

  /// Books an appointment and returns it.
  ///
  /// Throws [StateError] if the day is already full — the UI blocks this well
  /// before it can happen, but the guard keeps the invariant honest.
  Future<Appointment> book({
    required Doctor doctor,
    required DateTime date,
    required String patientName,
    required int patientAge,
    required String patientPhone,
    required String problem,
  }) async {
    final DateTime day = TimeUtils.dateOnly(date);

    if (isFull(doctor, day)) {
      throw StateError('This doctor is fully booked on the selected day.');
    }

    final int serial = nextSerial(doctor, day);

    final Appointment appointment = Appointment(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      doctorId: doctor.id,
      doctorName: doctor.name,
      specialty: doctor.specialty,
      hospital: doctor.hospital,
      patientName: patientName.trim(),
      patientAge: patientAge,
      patientPhone: patientPhone.trim(),
      problem: problem.trim(),
      date: day,
      serial: serial,
      estimatedTime: doctor.estimatedTimeForSerial(serial),
      fee: doctor.fee,
      status: AppointmentStatus.upcoming,
      createdAt: DateTime.now(),
    );

    _appointments.add(appointment);
    notifyListeners();
    await _save();

    return appointment;
  }

  /// Marks an appointment cancelled. Other serials are deliberately untouched.
  Future<void> cancel(String appointmentId) async {
    final int index =
        _appointments.indexWhere((Appointment a) => a.id == appointmentId);
    if (index == -1) return;

    _appointments[index] = _appointments[index]
        .copyWith(status: AppointmentStatus.cancelled);

    notifyListeners();
    await _save();
  }

  /// Reschedule = cancel the old booking + issue a brand new serial on the new
  /// day. The old day's slot stays consumed, and the patient gets a fresh
  /// serial and arrival time rather than inheriting the old one.
  Future<Appointment> reschedule({
    required Appointment appointment,
    required Doctor doctor,
    required DateTime newDate,
  }) async {
    await cancel(appointment.id);

    return book(
      doctor: doctor,
      date: newDate,
      patientName: appointment.patientName,
      patientAge: appointment.patientAge,
      patientPhone: appointment.patientPhone,
      problem: appointment.problem,
    );
  }

  /// Development helper — clears every booking. Not wired to any UI.
  Future<void> clearAll() async {
    _appointments = <Appointment>[];
    notifyListeners();
    await _save();
  }
}

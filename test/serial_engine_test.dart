import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:medibook/models/appointment.dart';
import 'package:medibook/models/doctor.dart';
import 'package:medibook/providers/appointment_provider.dart';
import 'package:medibook/utils/time_utils.dart';

/// Tests for the serial allocation engine — the core logic of MediBook.
///
/// The scheduling rules under test:
///   nextSerial    = issuedCount + 1   (cancelled bookings still count)
///   estimatedTime = startTime + (serial - 1) * consultMinutes
///   isFull        = issuedCount >= dailyLimit
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Sits Mon/Wed/Fri, starts 5:00 PM, 15 min per patient, limit 20.
  const Doctor drSrijon = Doctor(
    id: 'test-d1',
    name: 'Dr. Srijon Roy',
    specialty: 'Cardiologist',
    hospital: 'Popular Diagnostic Centre',
    rating: 4.8,
    experienceYears: 12,
    fee: 1000,
    bio: 'Test doctor.',
    availableDays: <int>[1, 3, 5],
    startHour: 17,
    startMinute: 0,
    consultMinutes: 15,
    dailyLimit: 20,
  );

  /// A second doctor with a deliberately small limit, for capacity tests.
  const Doctor drArif = Doctor(
    id: 'test-d2',
    name: 'Dr. Arif Chowdhury',
    specialty: 'Neurologist',
    hospital: 'Al-Haramain Hospital',
    rating: 4.6,
    experienceYears: 15,
    fee: 1200,
    bio: 'Test doctor.',
    availableDays: <int>[1, 4],
    startHour: 19,
    startMinute: 0,
    consultMinutes: 20,
    dailyLimit: 3,
  );

  final DateTime monday = TimeUtils.dateOnly(DateTime(2026, 8, 24));
  final DateTime wednesday = TimeUtils.dateOnly(DateTime(2026, 8, 26));

  late AppointmentProvider provider;

  /// Books one appointment with throwaway patient details.
  Future<Appointment> book(Doctor doctor, DateTime date) {
    return provider.book(
      doctor: doctor,
      date: date,
      patientName: 'Test Patient',
      patientAge: 25,
      patientPhone: '01712345678',
      problem: 'Testing the serial allocation engine.',
    );
  }

  setUp(() async {
    // Every test starts from an empty store.
    SharedPreferences.setMockInitialValues(<String, Object>{});
    provider = AppointmentProvider();
    await provider.load();
  });

  group('Serial allocation', () {
    test('first booking of the day receives serial 1', () async {
      expect(provider.nextSerial(drSrijon, monday), 1);

      final Appointment a = await book(drSrijon, monday);
      expect(a.serial, 1);
    });

    test('serials increment for each booking on the same day', () async {
      final Appointment first = await book(drSrijon, monday);
      final Appointment second = await book(drSrijon, monday);
      final Appointment third = await book(drSrijon, monday);

      expect(first.serial, 1);
      expect(second.serial, 2);
      expect(third.serial, 3);
    });

    test('serials are counted per day, not globally', () async {
      await book(drSrijon, monday);
      await book(drSrijon, monday);

      final Appointment onWednesday = await book(drSrijon, wednesday);
      expect(onWednesday.serial, 1,
          reason: 'A different date starts its own queue.');
    });

    test('serials are counted per doctor, not shared', () async {
      await book(drSrijon, monday);
      await book(drSrijon, monday);

      final Appointment other = await book(drArif, monday);
      expect(other.serial, 1,
          reason: 'Each doctor has an independent queue.');
    });
  });

  group('Estimated arrival time', () {
    test('serial 1 is seen at the doctor\'s start time', () async {
      final Appointment a = await book(drSrijon, monday);
      expect(a.estimatedTime, '5:00 PM');
    });

    test('each serial advances by the consultation duration', () async {
      final Appointment first = await book(drSrijon, monday);
      final Appointment second = await book(drSrijon, monday);
      final Appointment third = await book(drSrijon, monday);

      expect(first.estimatedTime, '5:00 PM');
      expect(second.estimatedTime, '5:15 PM');
      expect(third.estimatedTime, '5:30 PM');
    });

    test('the formula holds at the end of a full session', () {
      // Serial 20 = 5:00 PM + 19 * 15 min = 9:45 PM
      expect(drSrijon.estimatedTimeForSerial(20), '9:45 PM');
      expect(drSrijon.sessionEndLabel, '9:45 PM');
    });

    test('a different consultation duration produces a different spacing', () {
      // Dr Arif: 7:00 PM start, 20 min each.
      expect(drArif.estimatedTimeForSerial(1), '7:00 PM');
      expect(drArif.estimatedTimeForSerial(2), '7:20 PM');
      expect(drArif.estimatedTimeForSerial(3), '7:40 PM');
    });
  });

  group('Daily patient limit', () {
    test('a fresh day is not full and reports every slot as free', () {
      expect(provider.isFull(drArif, monday), isFalse);
      expect(provider.remainingSlots(drArif, monday), 3);
    });

    test('remaining slots decrease as bookings are made', () async {
      await book(drArif, monday);
      expect(provider.remainingSlots(drArif, monday), 2);

      await book(drArif, monday);
      expect(provider.remainingSlots(drArif, monday), 1);
    });

    test('the day becomes full once the limit is reached', () async {
      await book(drArif, monday);
      await book(drArif, monday);
      await book(drArif, monday);

      expect(provider.isFull(drArif, monday), isTrue);
      expect(provider.remainingSlots(drArif, monday), 0);
    });

    test('booking beyond the limit is rejected', () async {
      await book(drArif, monday);
      await book(drArif, monday);
      await book(drArif, monday);

      expect(() => book(drArif, monday), throwsStateError);
    });

    test('a full day does not block a different day', () async {
      await book(drArif, monday);
      await book(drArif, monday);
      await book(drArif, monday);

      final DateTime thursday = TimeUtils.dateOnly(DateTime(2026, 8, 27));
      expect(provider.isFull(drArif, thursday), isFalse);
    });
  });

  group('Cancellation policy', () {
    test('cancelling marks the appointment without removing it', () async {
      final Appointment a = await book(drSrijon, monday);
      await provider.cancel(a.id);

      expect(provider.byId(a.id)?.status, AppointmentStatus.cancelled);
      expect(provider.all.length, 1);
    });

    test('a cancelled serial is never reissued', () async {
      await book(drSrijon, monday); // #1
      final Appointment second = await book(drSrijon, monday); // #2
      await book(drSrijon, monday); // #3

      await provider.cancel(second.id);

      final Appointment next = await book(drSrijon, monday);
      expect(next.serial, 4,
          reason: 'Serial 2 was cancelled but must not be handed out again.');
    });

    test('cancelling does not renumber the other patients', () async {
      final Appointment first = await book(drSrijon, monday);
      final Appointment second = await book(drSrijon, monday);
      final Appointment third = await book(drSrijon, monday);

      await provider.cancel(first.id);

      expect(provider.byId(second.id)?.serial, 2);
      expect(provider.byId(second.id)?.estimatedTime, '5:15 PM');
      expect(provider.byId(third.id)?.serial, 3);
      expect(provider.byId(third.id)?.estimatedTime, '5:30 PM');
    });

    test('cancelled bookings still occupy their slot', () async {
      final Appointment a = await book(drArif, monday);
      await book(drArif, monday);
      await provider.cancel(a.id);

      expect(provider.remainingSlots(drArif, monday), 1);
      expect(provider.activeCountOn(drArif.id, monday), 1);
      expect(provider.issuedCountOn(drArif.id, monday), 2);
    });
  });

  group('Reschedule', () {
    test('cancels the old booking and issues a new serial', () async {
      final Appointment original = await book(drSrijon, monday);

      final Appointment moved = await provider.reschedule(
        appointment: original,
        doctor: drSrijon,
        newDate: wednesday,
      );

      expect(provider.byId(original.id)?.status, AppointmentStatus.cancelled);
      expect(moved.serial, 1);
      expect(moved.date, wednesday);
      expect(moved.estimatedTime, '5:00 PM');
    });

    test('carries the patient details across', () async {
      final Appointment original = await book(drSrijon, monday);

      final Appointment moved = await provider.reschedule(
        appointment: original,
        doctor: drSrijon,
        newDate: wednesday,
      );

      expect(moved.patientName, original.patientName);
      expect(moved.patientPhone, original.patientPhone);
      expect(moved.problem, original.problem);
    });
  });

  group('Persistence', () {
    test('appointments survive a provider reload', () async {
      await book(drSrijon, monday);
      await book(drSrijon, monday);

      final AppointmentProvider reloaded = AppointmentProvider();
      await reloaded.load();

      expect(reloaded.all.length, 2);
      expect(reloaded.nextSerial(drSrijon, monday), 3,
          reason: 'Serial state must be restored from storage, not reset.');
    });
  });
}

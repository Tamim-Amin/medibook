import '../utils/time_utils.dart';

enum AppointmentStatus { upcoming, completed, cancelled }

/// A booked appointment.
///
/// Doctor details (name, specialty, hospital, fee) are intentionally copied
/// into the appointment instead of being looked up by [doctorId] every time.
/// This keeps past appointments readable even if the doctor's demo data
/// changes, and avoids a lookup on every list rebuild.
///
/// This model IS persisted, so it implements [toJson] / [fromJson].
class Appointment {
  const Appointment({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.specialty,
    required this.hospital,
    required this.patientName,
    required this.patientAge,
    required this.patientPhone,
    required this.problem,
    required this.date,
    required this.serial,
    required this.estimatedTime,
    required this.fee,
    required this.status,
    required this.createdAt,
  });

  final String id;

  // Doctor snapshot
  final String doctorId;
  final String doctorName;
  final String specialty;
  final String hospital;

  // Patient details from the booking form
  final String patientName;
  final int patientAge;
  final String patientPhone;
  final String problem;

  // Scheduling
  final DateTime date;
  final int serial;

  /// Pre-formatted, e.g. "5:45 PM".
  final String estimatedTime;

  final int fee;
  final AppointmentStatus status;
  final DateTime createdAt;

  // ---------------------------------------------------------------------
  // Derived
  // ---------------------------------------------------------------------

  bool get isCancelled => status == AppointmentStatus.cancelled;

  bool get isUpcoming =>
      status == AppointmentStatus.upcoming &&
      !date.isBefore(TimeUtils.dateOnly(DateTime.now()));

  /// Cancelled appointments and past dates both belong in the History tab.
  bool get isPast => !isUpcoming;

  String get dateLabel => TimeUtils.formatDate(date);

  String get fullDateLabel => TimeUtils.formatFullDate(date);

  String get statusLabel {
    switch (status) {
      case AppointmentStatus.upcoming:
        return 'Upcoming';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
    }
  }

  // ---------------------------------------------------------------------
  // copyWith
  // ---------------------------------------------------------------------

  Appointment copyWith({
    AppointmentStatus? status,
    DateTime? date,
    int? serial,
    String? estimatedTime,
    String? patientName,
    int? patientAge,
    String? patientPhone,
    String? problem,
  }) {
    return Appointment(
      id: id,
      doctorId: doctorId,
      doctorName: doctorName,
      specialty: specialty,
      hospital: hospital,
      patientName: patientName ?? this.patientName,
      patientAge: patientAge ?? this.patientAge,
      patientPhone: patientPhone ?? this.patientPhone,
      problem: problem ?? this.problem,
      date: date ?? this.date,
      serial: serial ?? this.serial,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      fee: fee,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }

  // ---------------------------------------------------------------------
  // Serialisation — required for SharedPreferences
  // ---------------------------------------------------------------------

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'doctorId': doctorId,
        'doctorName': doctorName,
        'specialty': specialty,
        'hospital': hospital,
        'patientName': patientName,
        'patientAge': patientAge,
        'patientPhone': patientPhone,
        'problem': problem,
        'date': date.toIso8601String(),
        'serial': serial,
        'estimatedTime': estimatedTime,
        'fee': fee,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      doctorId: json['doctorId'] as String,
      doctorName: json['doctorName'] as String,
      specialty: json['specialty'] as String,
      hospital: json['hospital'] as String,
      patientName: json['patientName'] as String,
      patientAge: json['patientAge'] as int,
      patientPhone: json['patientPhone'] as String,
      problem: json['problem'] as String,
      date: DateTime.parse(json['date'] as String),
      serial: json['serial'] as int,
      estimatedTime: json['estimatedTime'] as String,
      fee: json['fee'] as int,
      status: AppointmentStatus.values.firstWhere(
        (AppointmentStatus s) => s.name == json['status'],
        orElse: () => AppointmentStatus.upcoming,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

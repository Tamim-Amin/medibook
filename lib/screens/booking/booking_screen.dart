import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/appointment.dart';
import '../../models/doctor.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_theme.dart';
import '../../utils/context_colors.dart';
import '../../utils/time_utils.dart';
import '../../utils/validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/date_selector.dart';
import '../../widgets/primary_button.dart';

/// Books an appointment with a doctor.
///
/// Also handles rescheduling: pass [rescheduleFrom] and the old booking is
/// cancelled as part of confirming the new one.
class BookingScreen extends StatefulWidget {
  const BookingScreen({
    super.key,
    required this.doctor,
    this.rescheduleFrom,
  });

  final Doctor doctor;
  final Appointment? rescheduleFrom;

  bool get isReschedule => rescheduleFrom != null;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _problem = TextEditingController();

  late final List<DateTime> _dates =
      TimeUtils.upcomingDatesFor(widget.doctor.availableDays, lookAheadDays: 21);

  DateTime? _selectedDate;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _prefill();
    _selectFirstOpenDate();
  }

  /// Saves the patient typing details they have already given us.
  void _prefill() {
    final Appointment? old = widget.rescheduleFrom;
    if (old != null) {
      _name.text = old.patientName;
      _age.text = old.patientAge.toString();
      _phone.text = old.patientPhone;
      _problem.text = old.problem;
      return;
    }

    final AuthProvider auth = context.read<AuthProvider>();
    _name.text = auth.currentUser?.name ?? '';
    _phone.text = auth.currentUser?.phone ?? '';
    if (auth.currentUser?.age != null) {
      _age.text = auth.currentUser!.age.toString();
    }
  }

  /// Lands the user on the first day that still has room, rather than a day
  /// they cannot book.
  void _selectFirstOpenDate() {
    if (_dates.isEmpty) return;

    final AppointmentProvider appointments =
        context.read<AppointmentProvider>();

    _selectedDate = _dates.firstWhere(
      (DateTime d) => !appointments.isFull(widget.doctor, d),
      orElse: () => _dates.first,
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _age.dispose();
    _phone.dispose();
    _problem.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (_selectedDate == null) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final AppointmentProvider provider = context.read<AppointmentProvider>();

    try {
      final Appointment booked = widget.isReschedule
          ? await provider.reschedule(
              appointment: widget.rescheduleFrom!,
              doctor: widget.doctor,
              newDate: _selectedDate!,
            )
          : await provider.book(
              doctor: widget.doctor,
              date: _selectedDate!,
              patientName: _name.text,
              patientAge: int.parse(_age.text.trim()),
              patientPhone: _phone.text,
              problem: _problem.text,
            );

      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.bookingConfirmation,
        arguments: booked,
      );
    } on StateError catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Doctor doctor = widget.doctor;
    final AppointmentProvider appointments =
        context.watch<AppointmentProvider>();

    if (_dates.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Book Appointment')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              'This doctor has no available days in the next three weeks.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: context.cTextSecondary),
            ),
          ),
        ),
      );
    }

    final DateTime date = _selectedDate!;
    final bool full = appointments.isFull(doctor, date);
    final int serial = appointments.nextSerial(doctor, date);
    final String estimated = appointments.nextEstimatedTime(doctor, date);
    final int left = appointments.remainingSlots(doctor, date);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isReschedule
            ? 'Reschedule Appointment'
            : 'Book Appointment'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 28),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: _DoctorStrip(doctor: doctor),
            ),
            if (widget.isReschedule)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                child: _Notice(
                  color: AppColors.warning,
                  icon: Icons.info_outline,
                  text:
                      'Your old booking (serial #${widget.rescheduleFrom!.serial} on '
                      '${widget.rescheduleFrom!.dateLabel}) will be cancelled and a new '
                      'serial issued.',
                ),
              ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Select a day',
                style: AppTextStyles.heading3
                    .copyWith(color: context.cTextPrimary),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Only ${doctor.availableDaysLabel} are shown — the days '
                '${doctor.name.split(' ').last} actually sits.',
                style: AppTextStyles.caption
                    .copyWith(color: context.cTextSecondary),
              ),
            ),
            const SizedBox(height: 12),
            DateSelector(
              dates: _dates,
              selectedDate: _selectedDate,
              onSelect: (DateTime d) => setState(() => _selectedDate = d),
              isFull: (DateTime d) => appointments.isFull(doctor, d),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: full
                  ? _Notice(
                      color: AppColors.error,
                      icon: Icons.block_rounded,
                      text:
                          'Fully booked for ${TimeUtils.formatDate(date)}. All '
                          '${doctor.dailyLimit} serials for this day have been issued. '
                          'Please choose another day.',
                    )
                  : _SerialPreview(
                      serial: serial,
                      estimatedTime: estimated,
                      remaining: left,
                      total: doctor.dailyLimit,
                    ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Patient details',
                style: AppTextStyles.heading3
                    .copyWith(color: context.cTextPrimary),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  AppTextField(
                    label: 'Patient Name',
                    hint: 'Who is the appointment for?',
                    controller: _name,
                    prefixIcon: Icons.person_outline,
                    textInputAction: TextInputAction.next,
                    enabled: !full,
                    validator: Validators.name,
                  ),
                  AppTextField(
                    label: 'Age',
                    hint: 'e.g. 23',
                    controller: _age,
                    prefixIcon: Icons.cake_outlined,
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textInputAction: TextInputAction.next,
                    enabled: !full,
                    validator: Validators.age,
                  ),
                  AppTextField(
                    label: 'Contact Number',
                    hint: '01712345678',
                    controller: _phone,
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    maxLength: 11,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textInputAction: TextInputAction.next,
                    enabled: !full,
                    validator: Validators.phone,
                  ),
                  AppTextField(
                    label: 'Describe the problem',
                    hint: 'Symptoms, how long, any medication already taken',
                    controller: _problem,
                    maxLines: 4,
                    enabled: !full,
                    validator: Validators.problem,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _FeeRow(fee: doctor.fee),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: PrimaryButton(
                label: full
                    ? 'Fully Booked'
                    : (widget.isReschedule
                        ? 'Confirm New Serial'
                        : 'Confirm Booking'),
                icon: full ? Icons.block_rounded : Icons.check_circle_outline,
                isLoading: _isSubmitting,
                onPressed: full ? null : _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorStrip extends StatelessWidget {
  const _DoctorStrip({required this.doctor});

  final Doctor doctor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.cSurface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: context.cBorder),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  doctor.name,
                  style: AppTextStyles.heading3
                      .copyWith(color: context.cTextPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  '${doctor.specialty} · ${doctor.hospital}',
                  style: AppTextStyles.caption
                      .copyWith(color: context.cTextSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text('Starts', style: AppTextStyles.caption),
              Text(doctor.startTimeLabel, style: AppTextStyles.price),
            ],
          ),
        ],
      ),
    );
  }
}

/// Shows the serial and arrival time the patient will get *before* they commit.
class _SerialPreview extends StatelessWidget {
  const _SerialPreview({
    required this.serial,
    required this.estimatedTime,
    required this.remaining,
    required this.total,
  });

  final int serial;
  final String estimatedTime;
  final int remaining;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cPrimary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: context.cPrimary.withValues(alpha: 0.30)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _Metric(
                  label: 'You will get serial',
                  value: '#$serial',
                ),
              ),
              Container(width: 1, height: 40, color: context.cBorder),
              Expanded(
                child: _Metric(
                  label: 'Estimated arrival',
                  value: estimatedTime,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : (total - remaining) / total,
              minHeight: 6,
              backgroundColor: context.cBorder,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            '$remaining of $total slots left for this day',
            style: AppTextStyles.caption.copyWith(color: context.cPrimary),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: context.cTextSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.heading2.copyWith(color: context.cPrimary),
        ),
      ],
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({
    required this.color,
    required this.icon,
    required this.text,
  });

  final Color color;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 19, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall
                  .copyWith(color: context.cTextPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeeRow extends StatelessWidget {
  const _FeeRow({required this.fee});

  final int fee;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Consultation fee',
          style: AppTextStyles.body.copyWith(color: context.cTextSecondary),
        ),
        Text('\u09F3 $fee', style: AppTextStyles.price),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../data/demo_diagnostics.dart';
import '../../data/demo_doctors.dart';
import '../../models/appointment.dart';
import '../../models/doctor.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/context_colors.dart';
import '../../widgets/appointment_card.dart';
import '../../widgets/diagnostics_price_card.dart';
import '../../widgets/doctor_card.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/section_header.dart';
import '../../widgets/serial_badge.dart';
import '../../widgets/skeleton_loader.dart';

/// TEMPORARY (Day 2 only).
///
/// Renders every custom widget with real demo data so layout and dark mode can
/// be verified before the real screens exist. Delete on Day 3.
class WidgetGalleryScreen extends StatefulWidget {
  const WidgetGalleryScreen({super.key, required this.onToggleTheme});

  final VoidCallback onToggleTheme;

  @override
  State<WidgetGalleryScreen> createState() => _WidgetGalleryScreenState();
}

class _WidgetGalleryScreenState extends State<WidgetGalleryScreen> {
  final Set<String> _favorites = <String>{};

  Appointment _sampleAppointment(Doctor doctor, AppointmentStatus status) {
    const int serial = 4;
    return Appointment(
      id: 'sample-${doctor.id}-${status.name}',
      doctorId: doctor.id,
      doctorName: doctor.name,
      specialty: doctor.specialty,
      hospital: doctor.hospital,
      patientName: 'Tamim Amin',
      patientAge: 23,
      patientPhone: '01700000000',
      problem: 'Chest discomfort for the last three days',
      date: DateTime.now().add(const Duration(days: 2)),
      serial: serial,
      estimatedTime: doctor.estimatedTimeForSerial(serial),
      fee: doctor.fee,
      status: status,
      createdAt: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Doctor doctor = kDemoDoctors.first;
    final bool isDark = context.isDark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Gallery'),
        actions: <Widget>[
          IconButton(
            onPressed: widget.onToggleTheme,
            tooltip: 'Toggle theme',
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: <Widget>[
          const SectionHeader(title: 'DoctorCard', actionLabel: 'See all'),
          DoctorCard(
            doctor: doctor,
            isFavorite: _favorites.contains(doctor.id),
            onFavoriteToggle: () => setState(() {
              _favorites.contains(doctor.id)
                  ? _favorites.remove(doctor.id)
                  : _favorites.add(doctor.id);
            }),
            onTap: () {},
          ),
          const SizedBox(height: 12),
          DoctorCard(doctor: kDemoDoctors[3], onTap: () {}),

          const SectionHeader(title: 'SerialBadge (full)'),
          SerialBadge(
            serial: 4,
            estimatedTime: doctor.estimatedTimeForSerial(4),
          ),

          const SectionHeader(title: 'AppointmentCard'),
          AppointmentCard(
            appointment: _sampleAppointment(doctor, AppointmentStatus.upcoming),
            onCancel: () {},
            onReschedule: () {},
          ),
          const SizedBox(height: 12),
          AppointmentCard(
            appointment:
                _sampleAppointment(kDemoDoctors[1], AppointmentStatus.cancelled),
          ),

          const SectionHeader(title: 'DiagnosticsPriceCard'),
          DiagnosticsPriceCard(
            item: kDemoCenters.first.tests.first,
            icon: Icons.monitor_heart_outlined,
          ),
          DiagnosticsPriceCard(
            item: kDemoCenters.first.medicines.first,
            icon: Icons.medication_outlined,
            accentColor: AppColors.accent,
          ),

          const SectionHeader(title: 'Skeleton loaders'),
          const DoctorCardSkeleton(),
          const SizedBox(height: 12),
          const AppointmentCardSkeleton(),
          const SizedBox(height: 12),
          const PriceItemSkeleton(),

          const SectionHeader(title: 'PrimaryButton'),
          PrimaryButton(
            label: 'Book Appointment',
            icon: Icons.calendar_month_outlined,
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            label: 'Continue as Guest',
            isOutlined: true,
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          PrimaryButton(label: 'Loading…', isLoading: true, onPressed: () {}),

          const SectionHeader(title: 'EmptyStateView'),
          SizedBox(
            height: 320,
            child: EmptyStateView(
              icon: Icons.event_busy_outlined,
              title: 'No appointments yet',
              message:
                  'Once you book a doctor, your serial number and estimated time will appear here.',
              actionLabel: 'Find a Doctor',
              onAction: () {},
            ),
          ),

          const SectionHeader(title: 'Data sanity check'),
          Text(
            '${kDemoDoctors.length} doctors · ${kSpecialties.length} specialties · '
            '${kDemoCenters.length} diagnostic centres',
            style: AppTextStyles.bodySmall
                .copyWith(color: context.cTextSecondary),
          ),
          const SizedBox(height: 6),
          Text(
            'Serial formula check — ${doctor.name}: starts ${doctor.startTimeLabel}, '
            '${doctor.consultMinutes} min each. '
            'Serial 1 → ${doctor.estimatedTimeForSerial(1)}, '
            'Serial 5 → ${doctor.estimatedTimeForSerial(5)}, '
            'Serial ${doctor.dailyLimit} → ${doctor.sessionEndLabel}',
            style: AppTextStyles.bodySmall
                .copyWith(color: context.cTextSecondary),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

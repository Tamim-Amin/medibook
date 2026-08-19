import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../models/appointment.dart';
import '../../models/doctor.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/doctor_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/context_colors.dart';
import '../../widgets/appointment_card.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/skeleton_loader.dart';
import 'appointment_details_sheet.dart';

/// Upcoming and past bookings.
class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
    @override
  void initState() {
    super.initState();
    // Reschedule needs the full Doctor object, which lives in DoctorProvider —
    // make sure it is loaded even if the user opened this tab first.
    final DoctorProvider doctors = context.read<DoctorProvider>();
    Future<void>.microtask(() => doctors.loadDoctors());
  }

  Future<void> _cancel(Appointment appointment) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Cancel this appointment?'),
        content: Text(
          'Serial #${appointment.serial} with ${appointment.doctorName} on '
              '${appointment.dateLabel} will be cancelled.\n\n'
              'Other patients keep their serial numbers and times — nothing shifts.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep it'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Cancel appointment'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await context.read<AppointmentProvider>().cancel(appointment.id);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Appointment cancelled')),
    );
  }

  void _reschedule(Appointment appointment) {
    final Doctor? doctor =
    context.read<DoctorProvider>().byId(appointment.doctorId);

    if (doctor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('This doctor is no longer available to book.')),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      AppRoutes.booking,
      arguments: BookingArgs(doctor: doctor, rescheduleFrom: appointment),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppointmentProvider provider = context.watch<AppointmentProvider>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Appointments'),
          bottom: TabBar(
            labelColor: context.cPrimary,
            unselectedLabelColor: context.cTextSecondary,
            indicatorColor: context.cPrimary,
            labelStyle: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
            tabs: <Widget>[
              Tab(text: 'Upcoming (${provider.upcoming.length})'),
              Tab(text: 'History (${provider.past.length})'),
            ],
          ),
        ),
        body: provider.isLoading
            ? ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
          itemCount: 3,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (_, _) => const AppointmentCardSkeleton(),
        )
            : TabBarView(
          children: <Widget>[
            _AppointmentList(
              appointments: provider.upcoming,
              emptyIcon: Icons.event_busy_outlined,
              emptyTitle: 'No upcoming appointments',
              emptyMessage:
              'Book a doctor and your serial number and estimated '
                  'arrival time will show up here.',
              emptyActionLabel: 'Find a Doctor',
              onEmptyAction: () =>
                  Navigator.pushNamed(context, AppRoutes.doctorList),
              onCancel: _cancel,
              onReschedule: _reschedule,
            ),
            _AppointmentList(
              appointments: provider.past,
              emptyIcon: Icons.history_rounded,
              emptyTitle: 'Nothing in your history yet',
              emptyMessage:
              'Past and cancelled appointments will be kept here for '
                  'your records.',
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentList extends StatelessWidget {
  const _AppointmentList({
    required this.appointments,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptyMessage,
    this.emptyActionLabel,
    this.onEmptyAction,
    this.onCancel,
    this.onReschedule,
  });

  final List<Appointment> appointments;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptyMessage;
  final String? emptyActionLabel;
  final VoidCallback? onEmptyAction;
  final void Function(Appointment)? onCancel;
  final void Function(Appointment)? onReschedule;

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return EmptyStateView(
        icon: emptyIcon,
        title: emptyTitle,
        message: emptyMessage,
        actionLabel: emptyActionLabel,
        onAction: onEmptyAction,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
      itemCount: appointments.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (BuildContext context, int i) {
        final Appointment appointment = appointments[i];
        return AppointmentCard(
          appointment: appointment,
          onTap: () => AppointmentDetailsSheet.show(context, appointment),
          onCancel: onCancel == null ? null : () => onCancel!(appointment),
          onReschedule:
          onReschedule == null ? null : () => onReschedule!(appointment),
        );
      },
    );
  }
}
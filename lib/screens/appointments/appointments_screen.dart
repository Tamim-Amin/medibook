import 'package:flutter/material.dart';

import '../../widgets/empty_state_view.dart';

/// Placeholder — replaced on Day 6 with the Upcoming / History tabs.
class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Appointments')),
      body: const EmptyStateView(
        icon: Icons.event_busy_outlined,
        title: 'No appointments yet',
        message:
            'Once you book a doctor, your serial number and estimated arrival '
            'time will appear here.',
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../widgets/empty_state_view.dart';

/// Placeholder — replaced on Day 6 with the diagnostic centre list.
class DiagnosticsScreen extends StatelessWidget {
  const DiagnosticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diagnostics')),
      body: const EmptyStateView(
        icon: Icons.biotech_outlined,
        title: 'Diagnostics',
        message:
            'Nearby diagnostic centres with their test and pharmacy price lists '
            'will be listed here.',
      ),
    );
  }
}

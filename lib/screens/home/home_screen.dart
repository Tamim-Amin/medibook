import 'package:flutter/material.dart';

import '../../widgets/empty_state_view.dart';

/// Placeholder — replaced on Day 4 with the hero banner, specialty category
/// grid and the Top Doctors list.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MediBook')),
      body: const EmptyStateView(
        icon: Icons.home_outlined,
        title: 'Home',
        message:
            'Doctor categories and recommendations will appear here once the '
            'doctor listing is connected.',
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../utils/app_text_styles.dart';
import '../utils/context_colors.dart';
import 'appointments/appointments_screen.dart';
import 'diagnostics/diagnostics_screen.dart';
import 'home/home_screen.dart';
import 'profile/profile_screen.dart';

/// The four-tab shell that hosts the main sections of the app.
///
/// [IndexedStack] is used instead of swapping widgets so each tab keeps its
/// scroll position and state when the user switches away and back.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const List<Widget> _tabs = <Widget>[
    HomeScreen(),
    AppointmentsScreen(),
    DiagnosticsScreen(),
    ProfileScreen(),
  ];

  void _select(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO(Day 4): navigate to the doctor listing screen.
          _select(0);
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.search_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: context.cSurface,
        elevation: 8,
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: 58,
          child: Row(
            children: <Widget>[
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Home',
                isActive: _index == 0,
                onTap: () => _select(0),
              ),
              _NavItem(
                icon: Icons.event_note_outlined,
                activeIcon: Icons.event_note_rounded,
                label: 'Bookings',
                isActive: _index == 1,
                onTap: () => _select(1),
              ),
              const SizedBox(width: 56), // space for the notched FAB
              _NavItem(
                icon: Icons.biotech_outlined,
                activeIcon: Icons.biotech_rounded,
                label: 'Diagnostics',
                isActive: _index == 2,
                onTap: () => _select(2),
              ),
              _NavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person_rounded,
                label: 'Profile',
                isActive: _index == 3,
                onTap: () => _select(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = isActive ? context.cPrimary : context.cTextSecondary;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(isActive ? activeIcon : icon, size: 23, color: color),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontSize: 10.5,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

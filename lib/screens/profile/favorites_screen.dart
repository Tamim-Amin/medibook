import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/doctor.dart';
import '../../providers/doctor_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../utils/app_routes.dart';
import '../../widgets/doctor_card.dart';
import '../../widgets/empty_state_view.dart';
import '../home/home_screen.dart' show DoctorProfileArgs;

/// Doctors the user has hearted. Persisted, so the list survives a restart.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoritesProvider favorites = context.watch<FavoritesProvider>();
    final DoctorProvider doctors = context.watch<DoctorProvider>();
    final List<Doctor> saved = favorites.favoritesFrom(doctors.allDoctors);

    return Scaffold(
      appBar: AppBar(title: const Text('Favourite Doctors')),
      body: saved.isEmpty
          ? EmptyStateView(
        icon: Icons.favorite_border_rounded,
        title: 'No favourites yet',
        message:
        'Tap the heart on any doctor to keep them here for quick access.',
        actionLabel: 'Find a Doctor',
        onAction: () =>
            Navigator.pushNamed(context, AppRoutes.doctorList),
      )
          : ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        itemCount: saved.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (BuildContext context, int i) {
          final Doctor doctor = saved[i];
          return DoctorCard(
            doctor: doctor,
            heroPrefix: 'fav',
            isFavorite: true,
            onFavoriteToggle: () =>
                context.read<FavoritesProvider>().toggle(doctor.id),
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.doctorProfile,
              arguments: DoctorProfileArgs(
                doctor: doctor,
                heroPrefix: 'fav',
              ),
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/demo_doctors.dart';
import '../../models/doctor.dart';
import '../../providers/doctor_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/context_colors.dart';
import '../../utils/time_utils.dart';
import '../../widgets/doctor_card.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/skeleton_loader.dart';
import '../home/home_screen.dart' show DoctorProfileArgs;

/// Searchable, filterable list of doctors.
///
/// The specialty filter and the day filter combine: picking "Dermatologist"
/// and "Tue" shows only dermatologists who actually sit on Tuesday.
class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key, this.initialSpecialty});

  /// Passed when the user arrives by tapping a category tile on Home.
  final String? initialSpecialty;

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    final DoctorProvider provider = context.read<DoctorProvider>();

    Future<void>.microtask(() async {
      await provider.loadDoctors();
      provider.clearFilters();
      if (widget.initialSpecialty != null) {
        provider.setSpecialty(widget.initialSpecialty);
      }
      if (mounted) _search.text = provider.searchQuery;
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DoctorProvider provider = context.watch<DoctorProvider>();
    final FavoritesProvider favorites = context.watch<FavoritesProvider>();
    final List<Doctor> results = provider.filteredDoctors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Doctor'),
        actions: <Widget>[
          if (provider.hasActiveFilters)
            TextButton(
              onPressed: () {
                _search.clear();
                context.read<DoctorProvider>().clearFilters();
              },
              child: const Text('Clear'),
            ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: TextField(
              controller: _search,
              onChanged: context.read<DoctorProvider>().setSearchQuery,
              style: AppTextStyles.body.copyWith(color: context.cTextPrimary),
              decoration: InputDecoration(
                hintText: 'Search by name, specialty or hospital',
                prefixIcon: const Icon(Icons.search_rounded, size: 21),
                suffixIcon: provider.searchQuery.isEmpty
                    ? null
                    : IconButton(
                  icon: const Icon(Icons.close_rounded, size: 19),
                  onPressed: () {
                    _search.clear();
                    context.read<DoctorProvider>().setSearchQuery('');
                  },
                ),
              ),
            ),
          ),
          _FilterRow(
            label: 'Specialty',
            children: kSpecialties
                .map((Specialty s) => _Chip(
              label: s.name,
              isSelected: provider.selectedSpecialty == s.name,
              onTap: () =>
                  context.read<DoctorProvider>().setSpecialty(s.name),
            ))
                .toList(),
          ),
          _FilterRow(
            label: 'Available day',
            children: List<Widget>.generate(7, (int i) {
              final int weekday = i + 1;
              return _Chip(
                label: TimeUtils.dayShort(weekday),
                isSelected: provider.selectedDay == weekday,
                onTap: () => context.read<DoctorProvider>().setDay(weekday),
              );
            }),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                Text(
                  provider.isLoading
                      ? 'Loading doctors…'
                      : '${results.length} doctor${results.length == 1 ? '' : 's'} found',
                  style: AppTextStyles.caption
                      .copyWith(color: context.cTextSecondary),
                ),
              ],
            ),
          ),
          Expanded(
            child: provider.isLoading
                ? ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              itemCount: 4,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, _) => const DoctorCardSkeleton(),
            )
                : results.isEmpty
                ? EmptyStateView(
              icon: Icons.search_off_rounded,
              title: 'No doctors match',
              message:
              'Try a different specialty, pick another day, or clear '
                  'the filters to see everyone.',
              actionLabel: 'Clear filters',
              onAction: () {
                _search.clear();
                context.read<DoctorProvider>().clearFilters();
              },
            )
                : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              itemCount: results.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (BuildContext context, int i) {
                final Doctor doctor = results[i];
                return DoctorCard(
                  doctor: doctor,
                  heroPrefix: 'list',
                  isFavorite: favorites.isFavorite(doctor.id),
                  onFavoriteToggle: () => context
                      .read<FavoritesProvider>()
                      .toggle(doctor.id),
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.doctorProfile,
                    arguments: DoctorProfileArgs(
                      doctor: doctor,
                      heroPrefix: 'list',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.label, required this.children});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 6),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: context.cTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: children.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (_, int i) => children[i],
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? context.cPrimary : context.cSurface,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? context.cPrimary : context.cBorder,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: isSelected ? Colors.white : context.cTextSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
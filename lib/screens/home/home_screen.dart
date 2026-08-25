import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/demo_doctors.dart';
import '../../models/appointment.dart';
import '../../models/doctor.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/doctor_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_theme.dart';
import '../../utils/context_colors.dart';
import '../../widgets/category_tile.dart';
import '../../widgets/doctor_card.dart';
import '../../widgets/next_appointment_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/skeleton_loader.dart';
import 'notifications_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Read the provider synchronously, then defer the call itself —
    // notifyListeners() cannot fire during a build.
    final DoctorProvider doctors = context.read<DoctorProvider>();
    Future<void>.microtask(() => doctors.loadDoctors());
  }

  void _openList({String? specialty}) {
    Navigator.pushNamed(context, AppRoutes.doctorList, arguments: specialty);
  }

  @override
  Widget build(BuildContext context) {
    final DoctorProvider doctors = context.watch<DoctorProvider>();
    final FavoritesProvider favorites = context.watch<FavoritesProvider>();
    final List<Appointment> upcoming =
        context.watch<AppointmentProvider>().upcoming;
    final String firstName =
        context.watch<AuthProvider>().currentUser?.name.split(' ').first ??
            'there';

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              context.read<DoctorProvider>().loadDoctors(force: true),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 90),
            children: <Widget>[
              _Greeting(
                name: firstName,
                reminderCount: upcoming.length,
                onBellTap: () => NotificationsSheet.show(context),
              ),
              const SizedBox(height: 18),
              _SearchBar(onTap: _openList),
              const SizedBox(height: 18),
              // The next appointment is the single most useful thing to show a
              // returning patient; the generic banner is only for new users.
              if (upcoming.isNotEmpty)
                NextAppointmentCard(
                  appointment: upcoming.first,
                  onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.main,
                        (Route<dynamic> r) => false,
                    arguments: 1,
                  ),
                )
              else
                const _HeroBanner(),
              const SectionHeader(title: 'Specialties'),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: kSpecialties.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.92,
                ),
                itemBuilder: (BuildContext context, int i) {
                  final Specialty specialty = kSpecialties[i];
                  return CategoryTile(
                    label: specialty.name,
                    icon: specialty.icon,
                    color: AppColors.categoryColor(i),
                    count: doctors.isLoading
                        ? null
                        : doctors.countForSpecialty(specialty.name),
                    onTap: () => _openList(specialty: specialty.name),
                  );
                },
              ),
              SectionHeader(
                title: 'Top Doctors',
                actionLabel: 'See all',
                onActionTap: _openList,
              ),
              if (doctors.isLoading)
                Column(
                  children: List<Widget>.generate(
                    3,
                        (_) => const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: DoctorCardSkeleton(),
                    ),
                  ),
                )
              else
                ...doctors.topDoctors.map(
                      (Doctor doctor) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: DoctorCard(
                      doctor: doctor,
                      heroPrefix: 'home',
                      isFavorite: favorites.isFavorite(doctor.id),
                      onFavoriteToggle: () =>
                          context.read<FavoritesProvider>().toggle(doctor.id),
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.doctorProfile,
                        arguments: DoctorProfileArgs(
                          doctor: doctor,
                          heroPrefix: 'home',
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Route arguments for the doctor profile screen.
///
/// The hero prefix travels with the doctor so the profile animates from
/// whichever list the user tapped.
class DoctorProfileArgs {
  const DoctorProfileArgs({required this.doctor, required this.heroPrefix});

  final Doctor doctor;
  final String heroPrefix;
}

class _Greeting extends StatelessWidget {
  const _Greeting({
    required this.name,
    required this.reminderCount,
    required this.onBellTap,
  });

  final String name;
  final int reminderCount;
  final VoidCallback onBellTap;

  String get _timeOfDay {
    final int hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _timeOfDay,
                style: AppTextStyles.bodySmall
                    .copyWith(color: context.cTextSecondary),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                style: AppTextStyles.heading2
                    .copyWith(color: context.cTextPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        InkWell(
          onTap: onBellTap,
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: context.cSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: context.cBorder),
                  boxShadow: AppTheme.cardShadow(context.isDark),
                ),
                child: Icon(Icons.notifications_none_rounded,
                    size: 22, color: context.cTextSecondary),
              ),
              if (reminderCount > 0)
                Positioned(
                  top: -3,
                  right: -3,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    constraints: const BoxConstraints(minWidth: 18),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: context.cBackground, width: 2),
                    ),
                    child: Text(
                      reminderCount > 9 ? '9+' : '$reminderCount',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radius),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: context.cSurface,
          borderRadius: BorderRadius.circular(AppTheme.radius),
          border: Border.all(color: context.cBorder),
          boxShadow: AppTheme.cardShadow(context.isDark),
        ),
        child: Row(
          children: <Widget>[
            Icon(Icons.search_rounded, size: 21, color: context.cTextSecondary),
            const SizedBox(width: 10),
            Text(
              'Search doctors or specialties',
              style: AppTextStyles.body.copyWith(color: context.cTextSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radius + 4),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Skip the queue',
                  style: AppTextStyles.heading3.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Get your serial number and estimated arrival time the moment '
                      'you book.',
                  style:
                  AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.confirmation_number_outlined,
                size: 32, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
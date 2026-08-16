import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/doctor.dart';
import '../../providers/favorites_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_theme.dart';
import '../../utils/context_colors.dart';
import '../../widgets/avatar_image.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/skeleton_loader.dart';
import '../../main.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_routes.dart';

/// Full profile for one doctor, including the availability rules that drive
/// the serial-based booking system.
class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key, required this.doctor});

  final Doctor doctor;

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _startBooking() async {
    final bool isLoggedIn = context.read<AuthProvider>().isLoggedIn;

    if (!isLoggedIn) {
      final Object? result =
          await Navigator.pushNamed(context, AppRoutes.login);
      if (!mounted || result != true) return;
    }

    if (!mounted) return;
    Navigator.pushNamed(
      context,
      AppRoutes.booking,
      arguments: BookingArgs(doctor: widget.doctor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Doctor doctor = widget.doctor;
    final FavoritesProvider favorites = context.watch<FavoritesProvider>();
    final bool isFavorite = favorites.isFavorite(doctor.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Profile'),
        actions: <Widget>[
          IconButton(
            onPressed: () =>
                context.read<FavoritesProvider>().toggle(doctor.id),
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? AppColors.error : null,
            ),
            tooltip: isFavorite ? 'Remove from favourites' : 'Add to favourites',
          ),
        ],
      ),
      body: _isLoading
          ? const _ProfileSkeleton()
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: <Widget>[
                _Header(doctor: doctor),
                const SizedBox(height: 18),
                Row(
                  children: <Widget>[
                    _StatCard(
                      icon: Icons.star_rounded,
                      value: doctor.rating.toStringAsFixed(1),
                      label: 'Rating',
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 10),
                    _StatCard(
                      icon: Icons.work_history_outlined,
                      value: '${doctor.experienceYears}y',
                      label: 'Experience',
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: 10),
                    _StatCard(
                      icon: Icons.payments_outlined,
                      value: '\u09F3${doctor.fee}',
                      label: 'Fee',
                      color: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                _SectionTitle('About'),
                const SizedBox(height: 8),
                Text(
                  doctor.bio,
                  style:
                      AppTextStyles.body.copyWith(color: context.cTextSecondary),
                ),
                const SizedBox(height: 22),
                _SectionTitle('Chamber & Availability'),
                const SizedBox(height: 10),
                _InfoCard(
                  rows: <_InfoRow>[
                    _InfoRow(
                      icon: Icons.local_hospital_outlined,
                      label: 'Chamber',
                      value: doctor.hospital,
                    ),
                    _InfoRow(
                      icon: Icons.event_available_outlined,
                      label: 'Sits on',
                      value: doctor.availableDaysLabel,
                    ),
                    _InfoRow(
                      icon: Icons.schedule_outlined,
                      label: 'Starts at',
                      value: doctor.startTimeLabel,
                    ),
                    _InfoRow(
                      icon: Icons.timelapse_outlined,
                      label: 'Per patient',
                      value: '${doctor.consultMinutes} minutes',
                    ),
                    _InfoRow(
                      icon: Icons.groups_outlined,
                      label: 'Daily limit',
                      value: '${doctor.dailyLimit} patients',
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: context.cPrimary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(AppTheme.radius),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.info_outline,
                          size: 18, color: context.cPrimary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Serial 1 is seen at ${doctor.startTimeLabel}. At full '
                          'capacity the last patient (serial ${doctor.dailyLimit}) '
                          'is seen around ${doctor.sessionEndLabel}.',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: context.cPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _isLoading
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: PrimaryButton(
                  label: 'Book Appointment',
                  icon: Icons.calendar_month_outlined,
                  onPressed: () {
                    _startBooking();
                  },
                ),
              ),
            ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.doctor});

  final Doctor doctor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AvatarImage(
          initials: doctor.initials,
          imageAsset: doctor.imageAsset,
          size: 84,
          radius: 22,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                doctor.name,
                style:
                    AppTextStyles.heading2.copyWith(color: context.cTextPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                doctor.specialty,
                style: AppTextStyles.body.copyWith(
                  color: context.cPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: <Widget>[
                  Icon(Icons.location_on_outlined,
                      size: 14, color: context.cTextSecondary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      doctor.hospital,
                      style: AppTextStyles.caption
                          .copyWith(color: context.cTextSecondary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: context.cSurface,
          borderRadius: BorderRadius.circular(AppTheme.radius),
          border: Border.all(color: context.cBorder),
        ),
        child: Column(
          children: <Widget>[
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 6),
            Text(
              value,
              style:
                  AppTextStyles.heading3.copyWith(color: context.cTextPrimary),
            ),
            const SizedBox(height: 1),
            Text(
              label,
              style: AppTextStyles.caption
                  .copyWith(color: context.cTextSecondary, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.heading3.copyWith(color: context.cTextPrimary),
    );
  }
}

class _InfoRow {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.rows});

  final List<_InfoRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: context.cSurface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: context.cBorder),
      ),
      child: Column(
        children: rows
            .map((_InfoRow row) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: <Widget>[
                      Icon(row.icon, size: 18, color: context.cTextSecondary),
                      const SizedBox(width: 12),
                      Text(
                        row.label,
                        style: AppTextStyles.bodySmall
                            .copyWith(color: context.cTextSecondary),
                      ),
                      const Spacer(),
                      Flexible(
                        child: Text(
                          row.value,
                          textAlign: TextAlign.right,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: context.cTextPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: const <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SkeletonBox(width: 84, height: 84, radius: 22),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SkeletonBox(width: 170, height: 18),
                    SizedBox(height: 10),
                    SkeletonBox(width: 110, height: 14),
                    SizedBox(height: 10),
                    SkeletonBox(width: 200, height: 12),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 22),
          SkeletonBox(height: 78, radius: 14),
          SizedBox(height: 24),
          SkeletonBox(width: 90, height: 16),
          SizedBox(height: 12),
          SkeletonBox(height: 12),
          SizedBox(height: 8),
          SkeletonBox(height: 12),
          SizedBox(height: 8),
          SkeletonBox(width: 220, height: 12),
          SizedBox(height: 26),
          SkeletonBox(height: 240, radius: 14),
        ],
      ),
    );
  }
}

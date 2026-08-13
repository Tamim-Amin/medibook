import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_theme.dart';

/// TEMPORARY (Day 1 only).
///
/// Renders the palette, typography and component styles so the theme can be
/// verified before any real screen exists. Delete this file on Day 3 once the
/// splash and onboarding screens are in place.
class DesignPreviewScreen extends StatelessWidget {
  const DesignPreviewScreen({super.key, required this.onToggleTheme});

  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MediBook Design System'),
        actions: <Widget>[
          IconButton(
            onPressed: onToggleTheme,
            tooltip: 'Toggle theme',
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          _SectionTitle('Brand colours', isDark: isDark),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const <Widget>[
              _Swatch('Primary', AppColors.primary),
              _Swatch('Primary Dark', AppColors.primaryDark),
              _Swatch('Primary Light', AppColors.primaryLight),
              _Swatch('Accent', AppColors.accent),
              _Swatch('Success', AppColors.success),
              _Swatch('Error', AppColors.error),
            ],
          ),
          const SizedBox(height: 28),
          _SectionTitle('Category colours', isDark: isDark),
          const SizedBox(height: 12),
          Row(
            children: List<Widget>.generate(
              AppColors.categoryColors.length,
                  (int i) => Expanded(
                child: Container(
                  height: 44,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: AppColors.categoryColor(i),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          _SectionTitle('Typography', isDark: isDark),
          const SizedBox(height: 12),
          _ThemedText('Heading 1 — MediBook', AppTextStyles.heading1, isDark),
          _ThemedText('Heading 2 — Find your doctor', AppTextStyles.heading2,
              isDark),
          _ThemedText('Heading 3 — Dr. Srijon Roy', AppTextStyles.heading3,
              isDark),
          _ThemedText(
              'Body — Serial 4, estimated arrival time 11:15 AM at Popular Diagnostic Centre.',
              AppTextStyles.body,
              isDark),
          _ThemedText('Body small — Dermatologist · 8 years experience',
              AppTextStyles.bodySmall, isDark),
          _ThemedText('Caption — Available Sun, Tue, Thu',
              AppTextStyles.caption, isDark),
          const Text('Price — ৳ 800', style: AppTextStyles.price),
          const SizedBox(height: 28),
          _SectionTitle('Components', isDark: isDark),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Book Appointment'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {},
            child: const Text('Continue as Guest'),
          ),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Search doctors or specialties',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: <Widget>[
              Chip(label: const Text('Cardiologist')),
              Chip(label: const Text('Dermatologist')),
              Chip(label: const Text('Dentist')),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              borderRadius: BorderRadius.circular(AppTheme.radius),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _ThemedText('Card surface preview',
                          AppTextStyles.heading3, isDark),
                      _ThemedText('This is what a DoctorCard will sit on.',
                          AppTextStyles.bodySmall, isDark),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text, {required this.isDark});

  final String text;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: AppTextStyles.caption.copyWith(
        letterSpacing: 1.2,
        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
      ),
    );
  }
}

class _ThemedText extends StatelessWidget {
  const _ThemedText(this.text, this.style, this.isDark);

  final String text;
  final TextStyle style;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final bool isSecondary = style.color == AppColors.textSecondary;
    final Color color = isDark
        ? (isSecondary ? AppColors.darkTextSecondary : AppColors.darkTextPrimary)
        : (style.color ?? AppColors.textPrimary);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: style.copyWith(color: color)),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch(this.label, this.color);

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 96,
          height: 56,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 96,
          child: Text(label, style: AppTextStyles.caption),
        ),
      ],
    );
  }
}
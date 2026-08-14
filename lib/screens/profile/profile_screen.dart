import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_theme.dart';
import '../../utils/context_colors.dart';
import '../../widgets/avatar_image.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/primary_button.dart';

/// Profile tab.
///
/// Day 3 version: session details, dark mode toggle and logout.
/// Day 7 adds Edit Profile and the Favourites link.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You will need to log in again to book an appointment.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await context.read<AuthProvider>().logout();
    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.welcome, (Route<dynamic> r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider auth = context.watch<AuthProvider>();
    final ThemeProvider theme = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 90),
        children: <Widget>[
          if (auth.isLoggedIn)
            _ProfileHeader(auth: auth)
          else
            SizedBox(
              height: 300,
              child: EmptyStateView(
                icon: Icons.person_outline,
                title: 'You are browsing as a guest',
                message:
                    'Log in to book appointments, save favourite doctors and '
                    'track your serials.',
                actionLabel: 'Login',
                onAction: () => Navigator.pushNamed(context, AppRoutes.login),
              ),
            ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: context.cSurface,
              borderRadius: BorderRadius.circular(AppTheme.radius),
              border: Border.all(color: context.cBorder),
            ),
            child: SwitchListTile(
              value: theme.isDark,
              onChanged: (bool v) => context.read<ThemeProvider>().setDark(v),
              secondary: Icon(Icons.dark_mode_outlined, color: context.cPrimary),
              title: Text(
                'Dark Mode',
                style: AppTextStyles.body.copyWith(color: context.cTextPrimary),
              ),
              subtitle: Text(
                'Saved on this device',
                style: AppTextStyles.caption
                    .copyWith(color: context.cTextSecondary),
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (auth.isLoggedIn)
            PrimaryButton(
              label: 'Log out',
              isOutlined: true,
              icon: Icons.logout_rounded,
              onPressed: () => _confirmLogout(context),
            ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.auth});

  final AuthProvider auth;

  @override
  Widget build(BuildContext context) {
    final String name = auth.currentUser?.name ?? '';
    final String email = auth.currentUser?.email ?? '';
    final String phone = auth.currentUser?.phone ?? '';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.cSurface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: context.cBorder),
      ),
      child: Row(
        children: <Widget>[
          AvatarImage(
            initials: auth.currentUser?.initials ?? '?',
            size: 62,
            radius: 20,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: AppTextStyles.heading3
                      .copyWith(color: context.cTextPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  email,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: context.cTextSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  phone,
                  style: AppTextStyles.caption
                      .copyWith(color: context.cTextSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

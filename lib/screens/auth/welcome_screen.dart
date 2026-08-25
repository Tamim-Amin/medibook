import 'package:flutter/material.dart';

import '../../utils/app_routes.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_theme.dart';
import '../../utils/context_colors.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/primary_button.dart';

/// Entry point after onboarding — login, register, or browse as a guest.
///
/// Guest access is a core promise of the project: an account is only needed at
/// the moment of booking.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: <Widget>[
              const Spacer(flex: 2),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: AppTheme.cardShadow(context.isDark),
                ),
                child: AppLogo(
                  size: 118,
                  radius: 32,
                  padding: 16,
                  background: context.cSurface,
                ),
              ),
              const SizedBox(height: 26),
              Text(
                'Welcome to MediBook',
                textAlign: TextAlign.center,
                style: AppTextStyles.heading1
                    .copyWith(color: context.cTextPrimary),
              ),
              const SizedBox(height: 12),
              Text(
                'Find a doctor, get your serial number instantly, and know your '
                    'estimated arrival time before you leave home.',
                textAlign: TextAlign.center,
                style:
                AppTextStyles.body.copyWith(color: context.cTextSecondary),
              ),
              const Spacer(flex: 3),
              PrimaryButton(
                label: 'Login',
                onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: 'Create an Account',
                isOutlined: true,
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.register),
              ),
              const SizedBox(height: 6),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, AppRoutes.main),
                child: Text(
                  'Continue as Guest',
                  style: AppTextStyles.body.copyWith(
                    color: context.cPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../utils/app_text_styles.dart';
import '../utils/prefs_keys.dart';
import '../providers/favorites_provider.dart';

/// First screen shown on launch.
///
/// Loads the saved theme and session, then decides where to go:
/// - onboarding not seen yet  → Onboarding
/// - session found            → Main shell
/// - otherwise                → Welcome
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final AuthProvider auth = context.read<AuthProvider>();
    final ThemeProvider theme = context.read<ThemeProvider>();
    final FavoritesProvider favorite = context.read<FavoritesProvider>();

    // Branding pause + real loading, whichever takes longer.
    final Future<void> minimumDelay =
        Future<void>.delayed(const Duration(milliseconds: 1400));

    await theme.load();
    await auth.loadSession();
    await favorite.load();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool seenOnboarding = prefs.getBool(PrefsKeys.seenOnboarding) ?? false;

    await minimumDelay;

    if (!mounted) return;

    final String next = !seenOnboarding
        ? AppRoutes.onboarding
        : (auth.isLoggedIn ? AppRoutes.main : AppRoutes.welcome);

    Navigator.pushReplacementNamed(context, next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.medical_services_rounded,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'MediBook',
              style: AppTextStyles.heading1
                  .copyWith(color: Colors.white, fontSize: 30),
            ),
            const SizedBox(height: 6),
            Text(
              'Book your serial, skip the queue',
              style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 40),
            const SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

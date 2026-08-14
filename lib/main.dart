import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/main_shell.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/splash_screen.dart';
import 'utils/app_routes.dart';
import 'utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MediBookApp());
}

class MediBookApp extends StatelessWidget {
  const MediBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        // TODO(Day 4): DoctorProvider, FavoritesProvider
        // TODO(Day 5): AppointmentProvider
      ],
      child: Consumer<ThemeProvider>(
        builder: (BuildContext context, ThemeProvider theme, Widget? child) {
          return MaterialApp(
            title: 'MediBook',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: theme.themeMode,
            initialRoute: AppRoutes.splash,
            routes: <String, WidgetBuilder>{
              AppRoutes.splash: (_) => const SplashScreen(),
              AppRoutes.onboarding: (_) => const OnboardingScreen(),
              AppRoutes.welcome: (_) => const WelcomeScreen(),
              AppRoutes.login: (_) => const LoginScreen(),
              AppRoutes.register: (_) => const RegisterScreen(),
              AppRoutes.main: (_) => const MainShell(),
              // TODO(Day 4): doctorList, doctorProfile, favorites
              // TODO(Day 5): booking, bookingConfirmation
              // TODO(Day 6): centerDetails
              // TODO(Day 7): editProfile
            },
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/appointment.dart';
import 'models/diagnostic_center.dart';
import 'models/doctor.dart';
import 'providers/appointment_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/doctor_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/booking/booking_confirmation_screen.dart';
import 'screens/booking/booking_screen.dart';
import 'screens/diagnostics/center_details_screen.dart';
import 'screens/doctors/doctor_list_screen.dart';
import 'screens/doctors/doctor_profile_screen.dart';
import 'screens/home/home_screen.dart' show DoctorProfileArgs;
import 'screens/main_shell.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/profile/favorites_screen.dart';
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
        ChangeNotifierProvider<DoctorProvider>(create: (_) => DoctorProvider()),
        ChangeNotifierProvider<FavoritesProvider>(
            create: (_) => FavoritesProvider()),
        ChangeNotifierProvider<AppointmentProvider>(
            create: (_) => AppointmentProvider()),
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
              AppRoutes.favorites: (_) => const FavoritesScreen(),
              AppRoutes.editProfile: (_) => const EditProfileScreen(),
              AppRoutes.main: (BuildContext context) {
                final Object? args =
                    ModalRoute.of(context)?.settings.arguments;
                return MainShell(initialIndex: args is int ? args : 0);
              },
              AppRoutes.doctorList: (BuildContext context) {
                final Object? args =
                    ModalRoute.of(context)?.settings.arguments;
                return DoctorListScreen(
                  initialSpecialty: args is String ? args : null,
                );
              },
              AppRoutes.doctorProfile: (BuildContext context) {
                final Object? args =
                    ModalRoute.of(context)!.settings.arguments;
                if (args is DoctorProfileArgs) {
                  return DoctorProfileScreen(
                    doctor: args.doctor,
                    heroPrefix: args.heroPrefix,
                  );
                }
                return DoctorProfileScreen(doctor: args! as Doctor);
              },
              AppRoutes.booking: (BuildContext context) {
                final Object? args =
                    ModalRoute.of(context)!.settings.arguments;
                if (args is BookingArgs) {
                  return BookingScreen(
                    doctor: args.doctor,
                    rescheduleFrom: args.rescheduleFrom,
                  );
                }
                return BookingScreen(doctor: args! as Doctor);
              },
              AppRoutes.bookingConfirmation: (BuildContext context) {
                final Appointment appointment =
                ModalRoute.of(context)!.settings.arguments! as Appointment;
                return BookingConfirmationScreen(appointment: appointment);
              },
              AppRoutes.centerDetails: (BuildContext context) {
                final DiagnosticCenter center = ModalRoute.of(context)!
                    .settings
                    .arguments! as DiagnosticCenter;
                return CenterDetailsScreen(center: center);
              },
            },
          );
        },
      ),
    );
  }
}

/// Route arguments for the booking screen.
///
/// A plain [Doctor] is enough for a new booking; rescheduling also needs the
/// appointment being replaced.
class BookingArgs {
  const BookingArgs({required this.doctor, this.rescheduleFrom});

  final Doctor doctor;
  final Appointment? rescheduleFrom;
}
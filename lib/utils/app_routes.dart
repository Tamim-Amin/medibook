/// All named routes in one place.
///
/// Screens are registered in `MaterialApp.routes` (see `main.dart`) as they are
/// built, so a few constants here are still ahead of the implementation.
class AppRoutes {
  AppRoutes._();

  // ---- Day 3 ----
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';

  // ---- Day 4 ----
  static const String doctorList = '/doctors';
  static const String doctorProfile = '/doctor-profile';
  static const String favorites = '/favorites';

  // ---- Day 5 ----
  static const String booking = '/booking';
  static const String bookingConfirmation = '/booking-confirmation';

  // ---- Day 6 ----
  static const String centerDetails = '/center-details';

  // ---- Day 7 ----
  static const String editProfile = '/edit-profile';
}
/// All named routes in one place.
///
/// Screens are added to `MaterialApp.routes` in `main.dart` as they get built,
/// so this list is intentionally ahead of the implementation.
class AppRoutes {
  AppRoutes._();

  // Day 1 only — remove once the real splash screen exists (Day 3).
  static const String designPreview = '/design-preview';

  //Day 2 only - remove once the real screens exist(Day 3)
  static const String widgetGallery = '/widget-gallery';

  // Day 3
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';

  // Day 4
  static const String doctorList = '/doctors';
  static const String doctorProfile = '/doctor-profile';
  static const String favorites = '/favorites';

  // Day 5
  static const String booking = '/booking';
  static const String bookingConfirmation = '/booking-confirmation';

  // Day 6
  static const String appointments = '/appointments';
  static const String diagnosticsCenters = '/diagnostics';
  static const String centerDetails = '/center-details';

  // Day 7
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
}
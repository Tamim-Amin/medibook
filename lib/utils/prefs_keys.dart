/// Every SharedPreferences key used in the app.
///
/// Using constants instead of raw strings prevents typo bugs where a value is
/// written under one key and read from another.
class PrefsKeys {
  PrefsKeys._();

  /// bool — true after the onboarding carousel has been completed once.
  static const String seenOnboarding = 'seen_onboarding';

  /// bool — true while a user session is active.
  static const String isLoggedIn = 'is_logged_in';

  /// String (JSON) — the currently logged-in user.
  static const String currentUser = 'current_user';

  /// String (JSON list) — all registered users (local demo auth).
  static const String registeredUsers = 'registered_users';

  /// List&lt;String&gt; — favourite doctor IDs.
  static const String favoriteDoctorIds = 'favorite_doctor_ids';

  /// String (JSON list) — all appointments.
  static const String appointments = 'appointments';

  /// bool — dark mode preference.
  static const String isDarkMode = 'is_dark_mode';
}
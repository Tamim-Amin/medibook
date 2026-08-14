import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/prefs_keys.dart';

/// Holds the app-wide theme mode and persists the user's choice.
///
/// Built on Day 3 (instead of Day 7) so `main.dart` never has to be
/// restructured later — Day 7 only adds the Settings toggle UI.
class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  /// Called once from the splash screen.
  Future<void> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool(PrefsKeys.isDarkMode) ?? false;
    notifyListeners();
  }

  Future<void> setDark(bool value) async {
    _isDark = value;
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PrefsKeys.isDarkMode, value);
  }

  Future<void> toggle() => setDark(!_isDark);
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_user.dart';
import '../utils/prefs_keys.dart';

/// Local, offline authentication.
///
/// Registered users live in SharedPreferences as a JSON list. There is no
/// server — this is deliberate (see the project plan: the app is fully
/// offline). Passwords are stored in plain text, which is acceptable for a
/// course demo but would be hashed or delegated to Firebase Auth in production.
class AuthProvider extends ChangeNotifier {
  AppUser? _currentUser;
  bool _isBusy = false;

  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isBusy => _isBusy;

  /// Convenience for the login screen hint and for graders testing the app.
  static const String demoEmail = 'demo@medibook.com';
  static const String demoPassword = '123456';

  // ---------------------------------------------------------------------
  // Session
  // ---------------------------------------------------------------------

  /// Restores the saved session. Called once from the splash screen.
  Future<void> loadSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await _seedDemoUser(prefs);

    final bool loggedIn = prefs.getBool(PrefsKeys.isLoggedIn) ?? false;
    final String? raw = prefs.getString(PrefsKeys.currentUser);

    if (loggedIn && raw != null) {
      _currentUser =
          AppUser.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    }
    notifyListeners();
  }

  /// Adds a ready-made account on first launch so the app can be tested
  /// without registering first.
  Future<void> _seedDemoUser(SharedPreferences prefs) async {
    final List<AppUser> users = _readUsers(prefs);
    if (users.any((AppUser u) => u.email == demoEmail)) return;

    users.add(const AppUser(
      name: 'Demo Patient',
      email: demoEmail,
      phone: '01712345678',
      password: demoPassword,
      age: 25,
    ));
    await _writeUsers(prefs, users);
  }

  // ---------------------------------------------------------------------
  // Register / login / logout
  // ---------------------------------------------------------------------

  /// Returns `null` on success, or an error message to show the user.
  Future<String?> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _setBusy(true);
    // Simulates the latency of a real request so the loading state is visible.
    await Future<void>.delayed(const Duration(milliseconds: 700));

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<AppUser> users = _readUsers(prefs);
    final String normalisedEmail = email.trim().toLowerCase();

    if (users.any((AppUser u) => u.email == normalisedEmail)) {
      _setBusy(false);
      return 'An account with this email already exists';
    }

    final AppUser user = AppUser(
      name: name.trim(),
      email: normalisedEmail,
      phone: phone.trim(),
      password: password,
    );

    users.add(user);
    await _writeUsers(prefs, users);
    await _startSession(prefs, user);

    _setBusy(false);
    return null;
  }

  /// Returns `null` on success, or an error message to show the user.
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    _setBusy(true);
    await Future<void>.delayed(const Duration(milliseconds: 700));

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<AppUser> users = _readUsers(prefs);
    final String normalisedEmail = email.trim().toLowerCase();

    AppUser? match;
    for (final AppUser u in users) {
      if (u.email == normalisedEmail && u.password == password) {
        match = u;
        break;
      }
    }

    if (match == null) {
      _setBusy(false);
      return 'Incorrect email or password';
    }

    await _startSession(prefs, match);
    _setBusy(false);
    return null;
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PrefsKeys.isLoggedIn, false);
    await prefs.remove(PrefsKeys.currentUser);
    _currentUser = null;
    notifyListeners();
  }

  /// Updates the logged-in user's details (used by Edit Profile on Day 7).
  Future<void> updateProfile(AppUser updated) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<AppUser> users = _readUsers(prefs);

    final int index =
        users.indexWhere((AppUser u) => u.email == updated.email);
    if (index != -1) {
      users[index] = updated;
      await _writeUsers(prefs, users);
    }

    await _startSession(prefs, updated);
  }

  // ---------------------------------------------------------------------
  // Storage helpers
  // ---------------------------------------------------------------------

  Future<void> _startSession(SharedPreferences prefs, AppUser user) async {
    await prefs.setBool(PrefsKeys.isLoggedIn, true);
    await prefs.setString(PrefsKeys.currentUser, jsonEncode(user.toJson()));
    _currentUser = user;
    notifyListeners();
  }

  List<AppUser> _readUsers(SharedPreferences prefs) {
    final String? raw = prefs.getString(PrefsKeys.registeredUsers);
    if (raw == null || raw.isEmpty) return <AppUser>[];

    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((dynamic e) => AppUser.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _writeUsers(
      SharedPreferences prefs, List<AppUser> users) async {
    final String encoded =
        jsonEncode(users.map((AppUser u) => u.toJson()).toList());
    await prefs.setString(PrefsKeys.registeredUsers, encoded);
  }

  void _setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }
}

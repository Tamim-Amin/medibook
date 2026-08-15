import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/doctor.dart';
import '../utils/prefs_keys.dart';

/// Favourite doctors, stored as a list of doctor IDs.
///
/// Only IDs are persisted — never the whole doctor. Doctors are static demo
/// data, so storing them again would duplicate data that already exists in
/// `demo_doctors.dart`.
class FavoritesProvider extends ChangeNotifier {
  final Set<String> _ids = <String>{};

  Set<String> get ids => Set<String>.unmodifiable(_ids);
  int get count => _ids.length;
  bool get isEmpty => _ids.isEmpty;

  bool isFavorite(String doctorId) => _ids.contains(doctorId);

  /// Called once from the splash screen.
  Future<void> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> saved =
        prefs.getStringList(PrefsKeys.favoriteDoctorIds) ?? <String>[];

    _ids
      ..clear()
      ..addAll(saved);
    notifyListeners();
  }

  Future<void> toggle(String doctorId) async {
    if (_ids.contains(doctorId)) {
      _ids.remove(doctorId);
    } else {
      _ids.add(doctorId);
    }
    notifyListeners();
    await _save();
  }

  /// Filters a doctor list down to the favourited ones, preserving order.
  List<Doctor> favoritesFrom(List<Doctor> doctors) =>
      doctors.where((Doctor d) => _ids.contains(d.id)).toList();

  Future<void> _save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        PrefsKeys.favoriteDoctorIds, _ids.toList(growable: false));
  }
}

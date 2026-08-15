import 'package:flutter/foundation.dart';

import '../data/demo_doctors.dart';
import '../models/doctor.dart';

/// Holds the doctor list and every active search / filter option.
///
/// The screens never filter the list themselves — they read [filteredDoctors].
/// Keeping the logic in one place means the Home screen, the listing screen and
/// the favourites screen can never disagree about what "Dermatologist on
/// Tuesday" means.
class DoctorProvider extends ChangeNotifier {
  List<Doctor> _all = <Doctor>[];
  bool _isLoading = false;
  bool _hasLoaded = false;

  String _searchQuery = '';
  String? _selectedSpecialty;
  int? _selectedDay;

  // ---------------------------------------------------------------------
  // Getters
  // ---------------------------------------------------------------------

  bool get isLoading => _isLoading;
  List<Doctor> get allDoctors => List<Doctor>.unmodifiable(_all);
  String get searchQuery => _searchQuery;
  String? get selectedSpecialty => _selectedSpecialty;
  int? get selectedDay => _selectedDay;

  bool get hasActiveFilters =>
      _searchQuery.isNotEmpty || _selectedSpecialty != null || _selectedDay != null;

  /// Highest rated doctors — shown in the "Top Doctors" section on Home.
  List<Doctor> get topDoctors {
    final List<Doctor> sorted = List<Doctor>.from(_all)
      ..sort((Doctor a, Doctor b) => b.rating.compareTo(a.rating));
    return sorted.take(5).toList();
  }

  /// Search AND specialty AND day — all three combine.
  List<Doctor> get filteredDoctors {
    final String query = _searchQuery.trim().toLowerCase();

    return _all.where((Doctor doctor) {
      final bool matchesQuery = query.isEmpty ||
          doctor.name.toLowerCase().contains(query) ||
          doctor.specialty.toLowerCase().contains(query) ||
          doctor.hospital.toLowerCase().contains(query);

      final bool matchesSpecialty =
          _selectedSpecialty == null || doctor.specialty == _selectedSpecialty;

      final bool matchesDay =
          _selectedDay == null || doctor.availableDays.contains(_selectedDay);

      return matchesQuery && matchesSpecialty && matchesDay;
    }).toList();
  }

  Doctor? byId(String id) {
    for (final Doctor d in _all) {
      if (d.id == id) return d;
    }
    return null;
  }

  int countForSpecialty(String specialty) =>
      _all.where((Doctor d) => d.specialty == specialty).length;

  // ---------------------------------------------------------------------
  // Loading
  // ---------------------------------------------------------------------

  /// Loads the demo data with a simulated network delay so the skeleton
  /// loaders have something real to wait for.
  Future<void> loadDoctors({bool force = false}) async {
    if (_hasLoaded && !force) return;

    _isLoading = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 900));

    _all = List<Doctor>.from(kDemoDoctors);
    _hasLoaded = true;
    _isLoading = false;
    notifyListeners();
  }

  // ---------------------------------------------------------------------
  // Filters
  // ---------------------------------------------------------------------

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  /// Passing the already-selected specialty clears it (chips toggle).
  void setSpecialty(String? specialty) {
    _selectedSpecialty = _selectedSpecialty == specialty ? null : specialty;
    notifyListeners();
  }

  /// Passing the already-selected weekday clears it.
  void setDay(int? weekday) {
    _selectedDay = _selectedDay == weekday ? null : weekday;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedSpecialty = null;
    _selectedDay = null;
    notifyListeners();
  }
}

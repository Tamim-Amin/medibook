import 'price_item.dart';

/// A diagnostic centre with its test and pharmacy price lists.
///
/// Static demo data — no serialisation needed.
class DiagnosticCenter {
  const DiagnosticCenter({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.openingHours,
    required this.tests,
    required this.medicines,
    this.imageAsset,
  });

  final String id;
  final String name;
  final String location;
  final double rating;

  /// e.g. "8:00 AM – 10:00 PM"
  final String openingHours;

  final List<PriceItem> tests;
  final List<PriceItem> medicines;

  final String? imageAsset;

  String get initials => name.isNotEmpty ? name[0].toUpperCase() : '?';

  int get totalItems => tests.length + medicines.length;
}

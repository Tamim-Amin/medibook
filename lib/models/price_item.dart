/// A single priced line item — either a diagnostic test or a medicine.
class PriceItem {
  const PriceItem({
    required this.name,
    required this.price,
    this.unit,
  });

  final String name;

  /// Price in BDT.
  final int price;

  /// Optional qualifier, e.g. "per test", "per strip (10 tablets)".
  final String? unit;

  /// "৳ 500"
  String get priceLabel => '\u09F3 $price';
}

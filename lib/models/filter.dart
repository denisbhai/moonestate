// lib/models/filter.dart
class FilterOptions {
  final List<String> types;
  final List<String> countries;
  final List<String> states;
  final List<String> cities;
  final PriceRange priceRange;

  FilterOptions({
    required this.types,
    required this.countries,
    required this.states,
    required this.cities,
    required this.priceRange,
  });

  factory FilterOptions.fromJson(Map<String, dynamic> json) {
    return FilterOptions(
      types: List<String>.from(json['types'] ?? []),
      countries: List<String>.from(json['countries'] ?? []),
      states: List<String>.from(json['states'] ?? []),
      cities: List<String>.from(json['cities'] ?? []),
      priceRange: PriceRange.fromJson(json['price_range'] ?? {}),
    );
  }
}

class PriceRange {
  final double min;
  final double max;

  PriceRange({required this.min, required this.max});

  factory PriceRange.fromJson(Map<String, dynamic> json) {
    return PriceRange(
      min: double.parse(json['min']?.toString() ?? '0'),
      max: double.parse(json['max']?.toString() ?? '1000000'),
    );
  }
}
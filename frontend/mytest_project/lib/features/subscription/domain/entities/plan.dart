class Plan {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final double price;
  final String currency;
  final String billingCycle;
  final bool isActive;
  final int sortOrder;
  final List<String> features;

  const Plan({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.price,
    required this.currency,
    required this.billingCycle,
    required this.isActive,
    required this.sortOrder,
    required this.features,
  });

  bool get isFree => slug == 'free';

  bool get isPremium => slug == 'premium';

  bool get isPropFirm => slug == 'prop_firm';

  String get displayPrice {
  if (price == 0) {
    return 'Free';
  }

  return '$currency $price / $billingCycle';
  }
}
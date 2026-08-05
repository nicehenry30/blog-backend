class Plan {
  final int id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final String billingCycle;
  final bool isActive;

  const Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.billingCycle,
    required this.isActive,
  });
}
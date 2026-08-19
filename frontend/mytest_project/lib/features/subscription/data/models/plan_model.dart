import '../../domain/entities/plan.dart';

class PlanModel extends Plan {
  const PlanModel({
    required super.id,
    required super.name,
    required super.slug,
    super.description,
    required super.price,
    required super.currency,
    required super.billingCycle,
    required super.isActive,
    required super.sortOrder,
    required super.features,
  });

  factory PlanModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PlanModel(
      id: json['id'],

      name: json['name'],

      slug: json['slug'],

      description: json['description'],

      price: (json['price'] as num).toDouble(),

      currency: json['currency'],

      billingCycle: json['billing_cycle'],

      isActive: json['is_active'],

      sortOrder: json['sort_order'],

      features: List<String>.from(
       json['features'] ?? const [],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'name': name,

      'slug': slug,

      'description': description,

      'price': price,

      'currency': currency,

      'billing_cycle': billingCycle,

      'is_active': isActive,

      'sort_order': sortOrder,

      'features': features,
    };
  }
}
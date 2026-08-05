import '../../domain/entities/plan.dart';

class PlanModel extends Plan {
  const PlanModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.currency,
    required super.billingCycle,
    required super.isActive,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: double.parse(json['price'].toString()),
      currency: json['currency'],
      billingCycle: json['billing_cycle'],
      isActive: json['is_active'],
    );
  }
}
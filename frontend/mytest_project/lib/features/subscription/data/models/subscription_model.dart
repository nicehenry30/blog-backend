import '../../domain/entities/subscription.dart';
import 'plan_model.dart';

class SubscriptionModel extends Subscription {
  const SubscriptionModel({
    required super.id,
    required super.status,
    required super.startsAt,
    required super.expiresAt,
    required super.autoRenew,
    required super.plan,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'],
      status: json['status'],
      startsAt: json['starts_at'] != null
          ? DateTime.parse(json['starts_at'])
          : null,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'])
          : null,
      autoRenew: json['auto_renew'],
      plan: PlanModel.fromJson(json['plan']),
    );
  }
}
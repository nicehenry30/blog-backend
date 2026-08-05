import 'plan.dart';

class Subscription {
  final int id;
  final String status;
  final DateTime? startsAt;
  final DateTime? expiresAt;
  final bool autoRenew;
  final Plan plan;

  const Subscription({
    required this.id,
    required this.status,
    required this.startsAt,
    required this.expiresAt,
    required this.autoRenew,
    required this.plan,
  });
}
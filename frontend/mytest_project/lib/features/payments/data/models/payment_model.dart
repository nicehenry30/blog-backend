import '../../domain/entities/payment.dart';

class PaymentModel extends Payment {
  const PaymentModel({
    required super.id,
    required super.subscriptionId,
    required super.amount,
    required super.currency,
    required super.status,
    required super.reference,
    super.transactionId,
    super.gateway,
    super.paidAt,
    required super.createdAt,
    super.planName,
  });

  factory PaymentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PaymentModel(
      id: json['id'],

      subscriptionId:
          json['subscription_id'],

      amount:
          (json['amount'] as num)
              .toDouble(),

      currency:
          json['currency'] ?? 'NGN',

      status:
          json['status'],

      reference:
          json['reference'],

      transactionId:
          json['transaction_id'],

      gateway:
          json['gateway'],

      paidAt:
          json['paid_at'] == null
              ? null
              : DateTime.parse(
                  json['paid_at'],
                ),

      createdAt: DateTime.parse(
        json['created_at'],
      ),

      planName:
          json['subscription']?['plan']
              ?['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subscription_id':
          subscriptionId,
      'amount': amount,
      'currency': currency,
      'status': status,
      'reference': reference,
      'transaction_id':
          transactionId,
      'gateway': gateway,
      'paid_at':
          paidAt?.toIso8601String(),
      'created_at':
          createdAt.toIso8601String(),
      'plan_name': planName,
    };
  }
}
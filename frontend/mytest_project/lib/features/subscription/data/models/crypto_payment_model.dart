import '../../domain/entities/crypto_payment.dart';

class CryptoPaymentModel extends CryptoPayment {
  const CryptoPaymentModel({
    required super.paymentId,
    required super.planId,
    required super.amountUsdt,
    required super.paymentMethod,
    required super.network,
    required super.walletAddress,
    required super.reference,
    required super.isUpgrade,
  });

  factory CryptoPaymentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final payment =
        json['payment'] as Map<String, dynamic>;

    final subscription =
        json['subscription'] as Map<String, dynamic>;

    return CryptoPaymentModel(
      paymentId: payment['id'] as int,
      planId: subscription['plan_id'] as int,
      amountUsdt:
          (json['amount_usdt'] as num).toDouble(),
      paymentMethod:
          json['payment_method'] as String,
      network:
          json['network'] as String,
      walletAddress:
          json['wallet_address'] as String,
      reference:
          json['reference'] as String,
      isUpgrade:
          json['is_upgrade'] as bool? ?? false,
    );
  }
}
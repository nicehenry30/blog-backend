class CryptoPayment {
  final int paymentId;
  final int planId;
  final double amountUsdt;
  final String paymentMethod;
  final String network;
  final String walletAddress;
  final String reference;
  final bool isUpgrade;

  const CryptoPayment({
    required this.paymentId,
    required this.planId,
    required this.amountUsdt,
    required this.paymentMethod,
    required this.network,
    required this.walletAddress,
    required this.reference,
    required this.isUpgrade,
  });
}
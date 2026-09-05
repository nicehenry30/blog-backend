class PaymentInitialization {
  final String authorizationUrl;
  final String accessCode;
  final String reference;
  final bool isUpgrade;

  const PaymentInitialization({
    required this.authorizationUrl,
    required this.accessCode,
    required this.reference,
    required this.isUpgrade,
  });
}
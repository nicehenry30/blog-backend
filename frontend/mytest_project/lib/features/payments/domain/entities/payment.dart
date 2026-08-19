class Payment {
  final int id;

  final int subscriptionId;

  final double amount;

  final String currency;

  final String status;

  final String reference;

  final String? transactionId;

  final String? gateway;

  final DateTime? paidAt;

  final DateTime createdAt;

  final String? planName;

  const Payment({
    required this.id,
    required this.subscriptionId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.reference,
    this.transactionId,
    this.gateway,
    this.paidAt,
    required this.createdAt,
    this.planName,
  });

  bool get isSuccessful =>
      status == 'successful';

  bool get isPending =>
      status == 'pending';

  bool get isFailed =>
      status == 'failed';

  String get formattedAmount =>
      '$currency ${amount.toStringAsFixed(2)}';
}
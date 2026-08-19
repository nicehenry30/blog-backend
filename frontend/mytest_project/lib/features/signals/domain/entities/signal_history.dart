class SignalHistory {
  final int id;
  final int signalId;
  final int? userId;
  final String event;
  final String? oldStatus;
  final String? newStatus;
  final String description;
  final List<dynamic> metadata;
  final DateTime createdAt;

  const SignalHistory({
    required this.id,
    required this.signalId,
    this.userId,
    required this.event,
    this.oldStatus,
    this.newStatus,
    required this.description,
    required this.metadata,
    required this.createdAt,
  });
}
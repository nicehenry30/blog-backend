class Feedback {
  final int id;
  final int userId;
  final String category;
  final String subject;
  final String message;
  final String? adminReply;
  final String status;
  final DateTime? repliedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Feedback({
    required this.id,
    required this.userId,
    required this.category,
    required this.subject,
    required this.message,
    this.adminReply,
    required this.status,
    this.repliedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get hasReply =>
      adminReply != null && adminReply!.trim().isNotEmpty;

  bool get isResolved =>
      status == 'resolved' || status == 'closed';
}
import '../../domain/entities/signal_history.dart';

class SignalHistoryModel extends SignalHistory {
  const SignalHistoryModel({
    required super.id,
    required super.signalId,
    super.userId,
    required super.event,
    super.oldStatus,
    super.newStatus,
    required super.description,
    required super.metadata,
    required super.createdAt,
  });

  factory SignalHistoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SignalHistoryModel(
      id: json['id'] as int,
      signalId: json['signal_id'] as int,
      userId: json['user_id'] as int?,
      event: json['event'] as String? ?? '',
      oldStatus: json['old_status'] as String?,
      newStatus: json['new_status'] as String?,
      description: json['description'] as String? ?? '',
      metadata: json['metadata'] is List
          ? List<dynamic>.from(json['metadata'])
          : [],
      createdAt: DateTime.parse(
        json['created_at'] as String,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'signal_id': signalId,
      'user_id': userId,
      'event': event,
      'old_status': oldStatus,
      'new_status': newStatus,
      'description': description,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
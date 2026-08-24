import '../../domain/entities/ai_signal_confirmation.dart';

class AiSignalConfirmationModel extends AiSignalConfirmation {
  const AiSignalConfirmationModel({
    required super.score,
    required super.review,
    required super.comment,
    required super.sampleSize,
    required super.wins,
    required super.losses,
    required super.breakevens,
    required super.averagePips,
    required super.tp1SuccessRate,
    required super.tp2SuccessRate,
    required super.tp3SuccessRate,
    required super.sufficientEvidence,
    required super.historicalAiScore,
    required super.evidenceLevel,
  });

  factory AiSignalConfirmationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final historical =
        json['historical'] as Map<String, dynamic>? ?? {};

    return AiSignalConfirmationModel(
      score: json['score'] != null
          ? (json['score'] as num).toDouble()
          : null,

      review: json['review'] as String?,

      comment: json['comment'] as String?,

      sampleSize:
          (historical['sample_size'] as num?)?.toInt() ?? 0,

      wins:
          (historical['wins'] as num?)?.toInt() ?? 0,

      losses:
          (historical['losses'] as num?)?.toInt() ?? 0,

      breakevens:
          (historical['breakevens'] as num?)?.toInt() ?? 0,

      averagePips:
          (historical['average_pips'] as num?)?.toDouble() ?? 0.0,

      tp1SuccessRate:
          (historical['tp1_success_rate'] as num?)?.toDouble() ?? 0.0,

      tp2SuccessRate:
          (historical['tp2_success_rate'] as num?)?.toDouble() ?? 0.0,

      tp3SuccessRate:
          (historical['tp3_success_rate'] as num?)?.toDouble() ?? 0.0,

      sufficientEvidence:
          historical['sufficient_evidence'] ?? false,

      historicalAiScore:
          historical['ai_score'] != null
              ? (historical['ai_score'] as num).toDouble()
              : null,

      evidenceLevel:
          historical['evidence_level'] as String? ?? 'insufficient',
    );
  }
}
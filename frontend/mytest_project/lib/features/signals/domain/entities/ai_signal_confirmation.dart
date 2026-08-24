class AiSignalConfirmation {
  final double? score;
  final String? review;
  final String? comment;

  final int sampleSize;
  final int wins;
  final int losses;
  final int breakevens;

  final double averagePips;

  final double tp1SuccessRate;
  final double tp2SuccessRate;
  final double tp3SuccessRate;

  final bool sufficientEvidence;
  final double? historicalAiScore;
  final String evidenceLevel;

  const AiSignalConfirmation({
    required this.score,
    required this.review,
    required this.comment,
    required this.sampleSize,
    required this.wins,
    required this.losses,
    required this.breakevens,
    required this.averagePips,
    required this.tp1SuccessRate,
    required this.tp2SuccessRate,
    required this.tp3SuccessRate,
    required this.sufficientEvidence,
    required this.historicalAiScore,
    required this.evidenceLevel,
  });
}
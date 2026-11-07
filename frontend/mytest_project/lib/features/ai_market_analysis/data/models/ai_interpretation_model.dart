class AiInterpretationModel {
  final String summary;
  final List<String> reasoning;
  final List<String> keyEvidence;
  final List<String> uncertainty;
  final String nextStep;
  final List<String> limitations;

  const AiInterpretationModel({
    required this.summary,
    required this.reasoning,
    required this.keyEvidence,
    required this.uncertainty,
    required this.nextStep,
    required this.limitations,
  });

  factory AiInterpretationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AiInterpretationModel(
      summary: json['summary'] as String,
      reasoning:
          (json['reasoning'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          const [],
      keyEvidence:
          (json['key_evidence'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          const [],
      uncertainty:
          (json['uncertainty'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          const [],
      nextStep: json['next_step'] as String,
      limitations:
          (json['limitations'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          const [],
    );
  }
}

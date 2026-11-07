class OpportunityAssessmentModel {
  final String direction;
  final String opportunity;
  final String agreement;
  final bool proceedToEntry;
  final List<String> supportingSources;
  final List<String> conflictingSources;
  final List<String> limitations;

  const OpportunityAssessmentModel({
    required this.direction,
    required this.opportunity,
    required this.agreement,
    required this.proceedToEntry,
    required this.supportingSources,
    required this.conflictingSources,
    required this.limitations,
  });

  factory OpportunityAssessmentModel.fromJson(Map<String, dynamic> json) {
    return OpportunityAssessmentModel(
      direction: json['direction'] as String,
      opportunity: json['opportunity'] as String,
      agreement: json['agreement'] as String,
      proceedToEntry: json['proceed_to_entry'] as bool,
      supportingSources:
          (json['supporting_sources'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          const [],
      conflictingSources:
          (json['conflicting_sources'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          const [],
      limitations:
          (json['limitations'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          const [],
    );
  }
}

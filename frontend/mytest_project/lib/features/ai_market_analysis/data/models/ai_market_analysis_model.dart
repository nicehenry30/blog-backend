import 'ai_interpretation_model.dart';
import 'opportunity_assessment_model.dart';

class AiMarketAnalysisModel {
  final String status;
  final dynamic evidence;
  final OpportunityAssessmentModel opportunityAssessment;
  final AiInterpretationModel aiInterpretation;
  final dynamic entryAnalysisContext;
  final dynamic entryAnalysis;
  final dynamic fiveMinuteConfirmation;
  final dynamic tradeProposal;
  final List<dynamic> validationErrors;

  const AiMarketAnalysisModel({
    required this.status,
    required this.evidence,
    required this.opportunityAssessment,
    required this.aiInterpretation,
    required this.entryAnalysisContext,
    required this.entryAnalysis,
    required this.fiveMinuteConfirmation,
    required this.tradeProposal,
    required this.validationErrors,
  });

  factory AiMarketAnalysisModel.fromJson(Map<String, dynamic> json) {
    return AiMarketAnalysisModel(
      status: json['status'] as String,
      evidence: json['evidence'],
      opportunityAssessment: OpportunityAssessmentModel.fromJson(
        json['opportunity_assessment'] as Map<String, dynamic>,
      ),
      aiInterpretation: AiInterpretationModel.fromJson(
        json['ai_interpretation'] as Map<String, dynamic>,
      ),
      entryAnalysisContext: json['entry_analysis_context'],
      entryAnalysis: json['entry_analysis'],
      fiveMinuteConfirmation: json['five_minute_confirmation'],
      tradeProposal: json['trade_proposal'],
      validationErrors:
          (json['validation_errors'] as List<dynamic>?) ?? const [],
    );
  }
}

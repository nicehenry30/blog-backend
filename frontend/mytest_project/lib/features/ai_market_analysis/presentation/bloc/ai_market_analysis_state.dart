import 'package:equatable/equatable.dart';

import '../../domain/entities/ai_market_analysis.dart';

abstract class AiMarketAnalysisState extends Equatable {
  const AiMarketAnalysisState();

  @override
  List<Object?> get props => [];
}

class AiMarketAnalysisInitial extends AiMarketAnalysisState {
  const AiMarketAnalysisInitial();
}

class AiMarketAnalysisLoading extends AiMarketAnalysisState {
  const AiMarketAnalysisLoading();
}

class AiMarketAnalysisSuccess extends AiMarketAnalysisState {
  final AiMarketAnalysis analysis;

  const AiMarketAnalysisSuccess(this.analysis);

  @override
  List<Object?> get props => [analysis];
}

class AiMarketAnalysisFailure extends AiMarketAnalysisState {
  final String message;

  const AiMarketAnalysisFailure(this.message);

  @override
  List<Object?> get props => [message];
}

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/analyze_market.dart';
import 'ai_market_analysis_event.dart';
import 'ai_market_analysis_state.dart';

class AiMarketAnalysisBloc
    extends Bloc<AiMarketAnalysisEvent, AiMarketAnalysisState> {
  final AnalyzeMarket analyzeMarket;

  AiMarketAnalysisBloc({required this.analyzeMarket})
    : super(const AiMarketAnalysisInitial()) {
    on<AnalyzeMarketRequested>(_onAnalyzeMarketRequested);
  }

  Future<void> _onAnalyzeMarketRequested(
    AnalyzeMarketRequested event,
    Emitter<AiMarketAnalysisState> emit,
  ) async {
    emit(const AiMarketAnalysisLoading());

    final result = await analyzeMarket(
      symbol: event.symbol,
      accountBalance: event.accountBalance,
      riskPercent: event.riskPercent,
    );

    result.fold(
      (failure) {
        emit(AiMarketAnalysisFailure(failure.message));
      },
      (analysis) {
        emit(AiMarketAnalysisSuccess(analysis));
      },
    );
  }
}

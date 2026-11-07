import 'package:equatable/equatable.dart';

abstract class AiMarketAnalysisEvent extends Equatable {
  const AiMarketAnalysisEvent();

  @override
  List<Object?> get props => [];
}

class AnalyzeMarketRequested extends AiMarketAnalysisEvent {
  final String symbol;
  final double accountBalance;
  final double riskPercent;

  const AnalyzeMarketRequested({
    required this.symbol,
    required this.accountBalance,
    required this.riskPercent,
  });

  @override
  List<Object?> get props => [
        symbol,
        accountBalance,
        riskPercent,
      ];
}

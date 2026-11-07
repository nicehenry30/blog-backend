import 'package:fpdart/fpdart.dart';

import 'package:mytest_project/core/error/failures.dart';

import '../entities/ai_market_analysis.dart';
import '../repository/ai_market_analysis_repository.dart';

class AnalyzeMarket {
  final AiMarketAnalysisRepository repository;

  const AnalyzeMarket(this.repository);

  Future<Either<Failure, AiMarketAnalysis>> call({
    required String symbol,
    required double accountBalance,
    required double riskPercent,
  }) {
    return repository.analyzeMarket(
      symbol: symbol,
      accountBalance: accountBalance,
      riskPercent: riskPercent,
    );
  }
}

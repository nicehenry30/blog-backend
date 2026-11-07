import 'package:fpdart/fpdart.dart';

import 'package:mytest_project/core/error/failures.dart';

import '../entities/ai_market_analysis.dart';

abstract class AiMarketAnalysisRepository {
  Future<Either<Failure, AiMarketAnalysis>> analyzeMarket({
    required String symbol,
    required double accountBalance,
    required double riskPercent,
  });
}

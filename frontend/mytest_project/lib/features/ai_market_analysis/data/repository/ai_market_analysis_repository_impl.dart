import 'package:fpdart/fpdart.dart';

import 'package:mytest_project/core/error/exceptions.dart';
import 'package:mytest_project/core/error/failures.dart';

import '../../domain/entities/ai_market_analysis.dart';
import '../../domain/repository/ai_market_analysis_repository.dart';
import '../datasources/ai_market_analysis_remote_data_source.dart';

class AiMarketAnalysisRepositoryImpl
    implements AiMarketAnalysisRepository {
  final AiMarketAnalysisRemoteDataSource remoteDataSource;

  const AiMarketAnalysisRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, AiMarketAnalysis>> analyzeMarket({
    required String symbol,
    required double accountBalance,
    required double riskPercent,
  }) async {
    try {
      final result = await remoteDataSource.analyzeMarket(
        symbol: symbol,
        accountBalance: accountBalance,
        riskPercent: riskPercent,
      );

      final analysis = AiMarketAnalysis(
        status: result.status,
        evidence: result.evidence,
        opportunityAssessment:
            result.opportunityAssessment,
        aiInterpretation: result.aiInterpretation,
        entryAnalysisContext:
            result.entryAnalysisContext,
        entryAnalysis: result.entryAnalysis,
        fiveMinuteConfirmation:
            result.fiveMinuteConfirmation,
        tradeProposal: result.tradeProposal,
        validationErrors: result.validationErrors,
      );

      return Right(analysis);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}

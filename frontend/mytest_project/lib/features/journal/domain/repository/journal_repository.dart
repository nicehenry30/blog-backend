import 'package:fpdart/fpdart.dart';
import 'package:mytest_project/core/error/failures.dart';
import 'package:mytest_project/features/journal/domain/entities/trade.dart';

abstract interface class JournalRepository {
  Future<Either<Failure, List<Trade>>> getTrades();

  Future<Either<Failure, void>> addTrade(Trade trade);

  Future<Either<Failure, void>> updateTrade(Trade trade);

  Future<Either<Failure, void>> deleteTrade(int tradeId);
}
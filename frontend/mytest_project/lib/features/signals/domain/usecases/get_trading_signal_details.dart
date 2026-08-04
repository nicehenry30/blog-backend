import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

import '../entities/trading_signal.dart';
import '../repository/trading_signal_repository.dart';

class GetTradingSignalDetails
    implements UseCase<TradingSignal, int> {
  final TradingSignalRepository repository;

  const GetTradingSignalDetails(this.repository);

  @override
  Future<Either<Failure, TradingSignal>> call(
    int signalId,
  ) {
    return repository.getSignalDetails(signalId);
  }
}
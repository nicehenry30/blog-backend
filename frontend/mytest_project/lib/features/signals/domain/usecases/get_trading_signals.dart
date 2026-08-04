import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

import '../entities/trading_signal.dart';
import '../repository/trading_signal_repository.dart';

class GetTradingSignals
    implements UseCase<List<TradingSignal>, NoParams> {
  final TradingSignalRepository repository;

  const GetTradingSignals(this.repository);

  @override
  Future<Either<Failure, List<TradingSignal>>> call(
    NoParams params,
  ) {
    return repository.getSignals();
  }
}
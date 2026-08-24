import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/ai_signal_confirmation.dart';
import '../entities/trading_signal.dart';

abstract interface class TradingSignalRepository {
  Future<Either<Failure, List<TradingSignal>>> getSignals();

  Future<Either<Failure, TradingSignal>> getSignalDetails(
    int signalId,
  );

  Future<Either<Failure, AiSignalConfirmation>> getAiConfirmation(
    int signalId,
  );
}
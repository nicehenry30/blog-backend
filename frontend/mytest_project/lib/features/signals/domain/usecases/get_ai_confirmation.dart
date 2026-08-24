import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/ai_signal_confirmation.dart';
import '../repository/trading_signal_repository.dart';

class GetAiConfirmation {
  final TradingSignalRepository repository;

  const GetAiConfirmation(this.repository);

  Future<Either<Failure, AiSignalConfirmation>> call(
    int signalId,
  ) {
    return repository.getAiConfirmation(signalId);
  }
}
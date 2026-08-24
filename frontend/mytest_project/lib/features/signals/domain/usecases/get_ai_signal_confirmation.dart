import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

import '../entities/ai_signal_confirmation.dart';
import '../repository/trading_signal_repository.dart';

class GetAiSignalConfirmation
    implements UseCase<AiSignalConfirmation, int> {
  final TradingSignalRepository repository;

  const GetAiSignalConfirmation(this.repository);

  @override
  Future<Either<Failure, AiSignalConfirmation>> call(
    int signalId,
  ) {
    return repository.getAiConfirmation(signalId);
  }
}
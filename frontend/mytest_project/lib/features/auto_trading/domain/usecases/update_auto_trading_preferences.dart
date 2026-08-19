import 'package:fpdart/fpdart.dart';

import 'package:mytest_project/core/error/failures.dart';
import 'package:mytest_project/features/auto_trading/domain/entities/auto_trading_settings.dart';
import 'package:mytest_project/features/auto_trading/domain/repository/auto_trading_repository.dart';

class UpdateAutoTradingPreferences {
  final AutoTradingRepository repository;

  UpdateAutoTradingPreferences(this.repository);

  Future<Either<Failure, AutoTradingSettings>> call({
    double? minimumSignalQuality,
    double? minimumAiConfidence,
    bool? allowBuy,
    bool? allowSell,
    bool? requireAiConfirmation,
    bool? requireStopLoss,
    bool? requireTakeProfit,
  }) {
    return repository.updateAutoTradingPreferences(
      minimumSignalQuality: minimumSignalQuality,
      minimumAiConfidence: minimumAiConfidence,
      allowBuy: allowBuy,
      allowSell: allowSell,
      requireAiConfirmation: requireAiConfirmation,
      requireStopLoss: requireStopLoss,
      requireTakeProfit: requireTakeProfit,
    );
  }
}

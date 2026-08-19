import 'package:fpdart/fpdart.dart';

import 'package:mytest_project/core/error/failures.dart';
import 'package:mytest_project/features/auto_trading/domain/entities/auto_trading_settings.dart';

abstract interface class AutoTradingRepository {
  Future<Either<Failure, AutoTradingSettings>>
      getAutoTradingSettings();

  Future<Either<Failure, AutoTradingSettings>>
      updateAutoTrading(bool enabled);

  Future<Either<Failure, AutoTradingSettings>>
      updateAutoTradingPreferences({
    double? minimumSignalQuality,
    double? minimumAiConfidence,
    bool? allowBuy,
    bool? allowSell,
    bool? requireAiConfirmation,
    bool? requireStopLoss,
    bool? requireTakeProfit,
  });
}
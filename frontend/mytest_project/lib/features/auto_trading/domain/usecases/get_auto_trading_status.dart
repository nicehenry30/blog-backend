import 'package:fpdart/fpdart.dart';

import 'package:mytest_project/core/error/failures.dart';
import 'package:mytest_project/features/auto_trading/domain/entities/auto_trading_settings.dart';
import 'package:mytest_project/features/auto_trading/domain/repository/auto_trading_repository.dart';

class GetAutoTradingStatus {
  final AutoTradingRepository repository;

  GetAutoTradingStatus(this.repository);

  Future<Either<Failure, AutoTradingSettings>> call() {
    return repository.getAutoTradingSettings();
  }
}
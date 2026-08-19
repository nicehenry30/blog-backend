import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/market_alert.dart';
import '../repositories/market_alert_repository.dart';

class GetMarketAlerts {
  final MarketAlertRepository repository;

  GetMarketAlerts(this.repository);

  Future<Either<Failure, List<MarketAlert>>> call() {
    return repository.getMarketAlerts();
  }
}

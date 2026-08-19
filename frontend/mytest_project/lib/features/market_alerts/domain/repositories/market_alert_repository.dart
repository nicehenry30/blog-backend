import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/market_alert.dart';

abstract interface class MarketAlertRepository {
  Future<Either<Failure, List<MarketAlert>>> getMarketAlerts();
}

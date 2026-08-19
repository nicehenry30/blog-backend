import 'package:mytest_project/features/market_alerts/data/models/market_alert_model.dart';

abstract interface class MarketAlertRemoteDataSource {
  Future<List<MarketAlertModel>> getMarketAlerts();
}
import '../../domain/entities/market_alert.dart';

abstract class MarketAlertState {}

class MarketAlertInitial extends MarketAlertState {}

class MarketAlertLoading extends MarketAlertState {}

class MarketAlertLoaded extends MarketAlertState {
  final List<MarketAlert> alerts;

  MarketAlertLoaded(this.alerts);
}

class MarketAlertFailure extends MarketAlertState {
  final String message;

  MarketAlertFailure(this.message);
}
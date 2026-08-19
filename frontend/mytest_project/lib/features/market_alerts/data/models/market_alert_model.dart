import '../../domain/entities/market_alert.dart';

class MarketAlertModel extends MarketAlert {
  const MarketAlertModel({
    required super.id,
    required super.title,
    required super.symbol,
    required super.impact,
    required super.alertTime,
    required super.recommendation,
    required super.isActive,
  });

  factory MarketAlertModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MarketAlertModel(
      id: json['id'] as int,
      title: json['title'] as String,
      symbol: json['symbol'] as String,
      impact: json['impact'] as String,
      alertTime: DateTime.parse(
        json['alert_time'] as String,
      ),
      recommendation: json['recommendation'] as String,
      isActive: json['is_active'] as bool,
    );
  }
}
import '../../domain/entities/trading_signal.dart';

class TradingSignalModel extends TradingSignal {
  const TradingSignalModel({
    required super.id,
    required super.symbolId,
    required super.symbol,
    required super.symbolName,
    required super.assetType,
    required super.brokerSymbol,
    required super.digits,
    required super.direction,
    required super.entryPrice,
    required super.stopLoss,
    required super.takeProfit,
    required super.timeframe,
    required super.signalQuality,
    required super.overallConfidence,
    super.strategy,
    required super.confluences,
    super.chartImage,
    super.chartImageUrl,
    required super.createdAt,
    super.publishedAt,
    required super.status,
  });

  factory TradingSignalModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final symbol =
        json['symbol'] as Map<String, dynamic>;

    return TradingSignalModel(
      id: json['id'],

      symbolId: symbol['id'],

      symbol: symbol['symbol'],

      symbolName: symbol['name'],

      assetType: symbol['asset_type'],

      brokerSymbol: symbol['broker_symbol'],

      digits: symbol['digits'],

      direction: json['direction'],

      entryPrice:
          (json['entry_price'] as num).toDouble(),

      stopLoss:
          (json['stop_loss'] as num).toDouble(),

      takeProfit:
          (json['take_profit'] as num).toDouble(),

      timeframe: json['timeframe'],

      signalQuality:
          (json['signal_quality'] as num)
              .toDouble(),

      overallConfidence:
          (json['overall_confidence'] as num)
              .toDouble(),

      strategy: json['strategy'],

      confluences:
          List<String>.from(
        json['confluences'] ?? [],
      ),

      chartImage: json['chart_image'],

      chartImageUrl:
          json['chart_image_url'],

      createdAt: DateTime.parse(
        json['created_at'],
      ),

      publishedAt:
          json['published_at'] != null
              ? DateTime.parse(
                  json['published_at'],
                )
              : null,

      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'symbol': {
        'id': symbolId,
        'symbol': symbol,
        'name': symbolName,
        'asset_type': assetType,
        'broker_symbol': brokerSymbol,
        'digits': digits,
      },

      'direction': direction,

      'entry_price': entryPrice,

      'stop_loss': stopLoss,

      'take_profit': takeProfit,

      'timeframe': timeframe,

      'signal_quality': signalQuality,

      'overall_confidence':
          overallConfidence,

      'strategy': strategy,

      'confluences': confluences,

      'chart_image': chartImage,

      'chart_image_url': chartImageUrl,

      'created_at':
          createdAt.toIso8601String(),

      'published_at':
          publishedAt?.toIso8601String(),

      'status': status,
    };
  }
}
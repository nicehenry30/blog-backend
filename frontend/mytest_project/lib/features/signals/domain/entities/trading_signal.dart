import 'signal_history.dart';

class TradingSignal {
  final int id;

  final int symbolId;
  final String symbol;
  final String symbolName;
  final String assetType;
  final String brokerSymbol;
  final int digits;

  final String? analysis;
  final double? aiScore;
  final String? aiComment;

  final String direction;

  final double entryPrice;
  final double stopLoss;
  final double takeProfit;

  // NEW
  final double? takeProfit2;
  final double? takeProfit3;

  final String timeframe;

  final double signalQuality;
  final double overallConfidence;

  final String? strategy;

  final List<String> confluences;

  final String? chartImage;
  final String? chartImageUrl;

  final DateTime createdAt;
  final DateTime? publishedAt;

  final List<SignalHistory> histories;

  final String status;

  // ==========================
  // Subscription Fields
  // ==========================

  final String visibility;

  final bool locked;

  final bool canView;

  final String? upgradePlan;

  const TradingSignal({
    required this.id,

    required this.symbolId,
    required this.symbol,
    required this.symbolName,
    required this.assetType,
    required this.brokerSymbol,
    required this.digits,

    this.analysis,
    this.aiScore,
    this.aiComment,

    required this.direction,

    required this.entryPrice,
    required this.stopLoss,
    required this.takeProfit,

    this.takeProfit2,
    this.takeProfit3,

    required this.timeframe,

    required this.signalQuality,
    required this.overallConfidence,

    this.strategy,

    required this.confluences,

    this.chartImage,
    this.chartImageUrl,

    required this.createdAt,
    this.publishedAt,

    required this.status,

    // NEW
    required this.visibility,
    required this.locked,
    required this.canView,
    this.upgradePlan,

    required this.histories,
  });
}
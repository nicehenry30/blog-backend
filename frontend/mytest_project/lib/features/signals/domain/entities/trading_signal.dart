class TradingSignal {
  final int id;

  final int symbolId;

  final String symbol;

  final String symbolName;

  final String assetType;

  final String brokerSymbol;

  final int digits;

  final String direction;

  final double entryPrice;

  final double stopLoss;

  final double takeProfit;

  final String timeframe;

  final double signalQuality;

  final double overallConfidence;

  final String? strategy;

  final List<String> confluences;

  final String? chartImage;

  final String? chartImageUrl;

  final DateTime createdAt;

  final DateTime? publishedAt;

  final String status;

  const TradingSignal({
    required this.id,
    required this.symbolId,
    required this.symbol,
    required this.symbolName,
    required this.assetType,
    required this.brokerSymbol,
    required this.digits,
    required this.direction,
    required this.entryPrice,
    required this.stopLoss,
    required this.takeProfit,
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
  });
}
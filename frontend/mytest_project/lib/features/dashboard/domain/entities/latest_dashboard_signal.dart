class LatestDashboardSignal {
  final int id;
  final String symbol;
  final String direction;
  final double entryPrice;
  final double stopLoss;
  final double takeProfit;
  final double? takeProfit2;
  final double? takeProfit3;
  final String timeframe;
  final String strategy;
  final String status;
  final double signalQuality;
  final double overallConfidence;

  const LatestDashboardSignal({
    required this.id,
    required this.symbol,
    required this.direction,
    required this.entryPrice,
    required this.stopLoss,
    required this.takeProfit,
    this.takeProfit2,
    this.takeProfit3,
    required this.timeframe,
    required this.strategy,
    required this.status,
    required this.signalQuality,
    required this.overallConfidence,
  });
}

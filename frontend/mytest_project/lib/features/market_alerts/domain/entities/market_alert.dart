class MarketAlert {
  final int id;
  final String title;
  final String symbol;
  final String impact;
  final DateTime alertTime;
  final String recommendation;
  final bool isActive;

  const MarketAlert({
    required this.id,
    required this.title,
    required this.symbol,
    required this.impact,
    required this.alertTime,
    required this.recommendation,
    required this.isActive,
  });
}
class DashboardData {
  final String plan;
  final double riskPerTrade;
  final double dailyLoss;
  final double drawdown;

  final bool mt4Connected;
  final bool mt5Connected;

  DashboardData({
    required this.plan,
    required this.riskPerTrade,
    required this.dailyLoss,
    required this.drawdown,
    required this.mt4Connected,
    required this.mt5Connected,
  });
}
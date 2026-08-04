class DashboardRisk {
  final double riskPerTrade;
  final double dailyLossLimit;
  final double maxDrawdown;

  const DashboardRisk({
    required this.riskPerTrade,
    required this.dailyLossLimit,
    required this.maxDrawdown,
  });
}
class DashboardStats {
  final int totalTrades;
  final int winningTrades;
  final int losingTrades;

  final double winRate;
  final double totalProfit;

  const DashboardStats({
    required this.totalTrades,
    required this.winningTrades,
    required this.losingTrades,
    required this.winRate,
    required this.totalProfit,
  });
}
import 'package:mytest_project/features/dashboard/domain/entities/dashboard_stats.dart';

class DashboardStatsModel extends DashboardStats {
  const DashboardStatsModel({
    required super.totalTrades,
    required super.winningTrades,
    required super.losingTrades,
    required super.winRate,
    required super.totalProfit,
  });

  factory DashboardStatsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DashboardStatsModel(
      totalTrades: (json['total_trades'] as num?)?.toInt() ?? 0,
      winningTrades:
          (json['winning_trades'] as num?)?.toInt() ?? 0,
      losingTrades:
          (json['losing_trades'] as num?)?.toInt() ?? 0,
      winRate:
          (json['win_rate'] as num?)?.toDouble() ?? 0.0,
      totalProfit:
          (json['total_profit'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_trades': totalTrades,
      'winning_trades': winningTrades,
      'losing_trades': losingTrades,
      'win_rate': winRate,
      'total_profit': totalProfit,
    };
  }
}
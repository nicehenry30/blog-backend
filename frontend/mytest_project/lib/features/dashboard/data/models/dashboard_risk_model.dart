import 'package:mytest_project/features/dashboard/domain/entities/dashboard_risk.dart';

class DashboardRiskModel extends DashboardRisk {
  const DashboardRiskModel({
    required super.riskPerTrade,
    required super.dailyLossLimit,
    required super.maxDrawdown,
  });

  factory DashboardRiskModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DashboardRiskModel(
      riskPerTrade:
          (json['risk_per_trade'] as num?)?.toDouble() ?? 0.0,
      dailyLossLimit:
          (json['daily_loss_limit'] as num?)?.toDouble() ?? 0.0,
      maxDrawdown:
          (json['max_drawdown'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'risk_per_trade': riskPerTrade,
      'daily_loss_limit': dailyLossLimit,
      'max_drawdown': maxDrawdown,
    };
  }
}
import 'package:mytest_project/features/dashboard/domain/entities/dashboard.dart';
import 'package:mytest_project/features/dashboard/data/models/dashboard_risk_model.dart';
import 'package:mytest_project/features/dashboard/data/models/dashboard_stats_model.dart';

class DashboardModel extends Dashboard {
  const DashboardModel({
    required super.risk,
    required super.stats,
  });

  factory DashboardModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DashboardModel(
      risk: DashboardRiskModel.fromJson(
        json['risk'] as Map<String, dynamic>? ?? {},
      ),
      stats: DashboardStatsModel.fromJson(
        json['stats'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}
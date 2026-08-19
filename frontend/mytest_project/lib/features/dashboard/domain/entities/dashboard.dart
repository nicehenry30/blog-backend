import 'package:mytest_project/features/dashboard/domain/entities/dashboard_risk.dart';
import 'package:mytest_project/features/dashboard/domain/entities/dashboard_stats.dart';
import 'package:mytest_project/features/dashboard/domain/entities/latest_dashboard_signal.dart';

class Dashboard {
  final DashboardRisk risk;
  final DashboardStats stats;
  final LatestDashboardSignal? latestSignal;

  const Dashboard({
    required this.risk,
    required this.stats,
    this.latestSignal,
  });
}
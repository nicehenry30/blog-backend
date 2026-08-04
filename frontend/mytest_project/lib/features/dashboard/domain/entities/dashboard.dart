import 'package:mytest_project/features/dashboard/domain/entities/dashboard_risk.dart';
import 'package:mytest_project/features/dashboard/domain/entities/dashboard_stats.dart';

class Dashboard {
  final DashboardRisk risk;
  final DashboardStats stats;

  const Dashboard({
    required this.risk,
    required this.stats,
  });
}
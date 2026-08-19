import 'package:mytest_project/features/dashboard/domain/entities/dashboard.dart';
import 'package:mytest_project/features/dashboard/domain/entities/latest_dashboard_signal.dart';
import 'package:mytest_project/features/dashboard/data/models/dashboard_risk_model.dart';
import 'package:mytest_project/features/dashboard/data/models/dashboard_stats_model.dart';

class DashboardModel extends Dashboard {
  const DashboardModel({
    required super.risk,
    required super.stats,
    super.latestSignal,
  });

  factory DashboardModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final latestSignalJson =
        json['latest_signal'] as Map<String, dynamic>?;

    return DashboardModel(
      risk: DashboardRiskModel.fromJson(
        json['risk'] as Map<String, dynamic>? ?? {},
      ),

      stats: DashboardStatsModel.fromJson(
        json['stats'] as Map<String, dynamic>? ?? {},
      ),

      latestSignal: latestSignalJson == null
          ? null
          : LatestDashboardSignal(
              id: int.tryParse(
                    latestSignalJson['id']?.toString() ?? '',
                  ) ??
                  0,

              symbol:
                  latestSignalJson['symbol']?.toString() ?? '',

              direction:
                  latestSignalJson['direction']?.toString() ?? '',

              entryPrice:
                  double.tryParse(
                        latestSignalJson['entry_price']?.toString() ?? '',
                      ) ??
                      0.0,

              stopLoss:
                  double.tryParse(
                        latestSignalJson['stop_loss']?.toString() ?? '',
                      ) ??
                      0.0,

              takeProfit:
                  double.tryParse(
                        latestSignalJson['take_profit']?.toString() ?? '',
                      ) ??
                      0.0,

              takeProfit2:
                  latestSignalJson['take_profit_2'] == null
                      ? null
                      : double.tryParse(
                          latestSignalJson['take_profit_2'].toString(),
                        ),

              takeProfit3:
                  latestSignalJson['take_profit_3'] == null
                      ? null
                      : double.tryParse(
                          latestSignalJson['take_profit_3'].toString(),
                        ),

              timeframe:
                  latestSignalJson['timeframe']?.toString() ?? '',

              strategy:
                  latestSignalJson['strategy']?.toString() ?? '',

              status:
                  latestSignalJson['status']?.toString() ?? '',

              signalQuality:
                  double.tryParse(
                        latestSignalJson['signal_quality']?.toString() ?? '',
                      ) ??
                      0.0,

              overallConfidence:
                  double.tryParse(
                        latestSignalJson['overall_confidence']?.toString() ??
                            '',
                      ) ??
                      0.0,
            ),
    );
  }
}
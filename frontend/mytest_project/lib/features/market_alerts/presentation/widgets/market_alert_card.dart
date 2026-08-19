import 'package:flutter/material.dart';

import 'package:mytest_project/features/market_alerts/domain/entities/market_alert.dart';

class MarketAlertCard extends StatelessWidget {
  final MarketAlert alert;

  const MarketAlertCard({
    super.key,
    required this.alert,
  });

  Color get impactColor {
    switch (alert.impact.toLowerCase()) {
      case 'high':
        return Colors.red;

      case 'medium':
        return Colors.orange;

      case 'low':
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  IconData get impactIcon {
    switch (alert.impact.toLowerCase()) {
      case 'high':
        return Icons.warning_rounded;

      case 'medium':
        return Icons.priority_high_rounded;

      case 'low':
        return Icons.info_outline_rounded;

      default:
        return Icons.notifications_none;
    }
  }

  String get impactLabel {
    switch (alert.impact.toLowerCase()) {
      case 'high':
        return 'HIGH IMPACT';

      case 'medium':
        return 'MEDIUM IMPACT';

      case 'low':
        return 'LOW IMPACT';

      default:
        return alert.impact.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: impactColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    impactIcon,
                    color: impactColor,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Text(
                        alert.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        alert.symbol,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: impactColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    impactLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: impactColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Alert time
            Row(
              children: [
                Icon(
                  Icons.schedule_outlined,
                  size: 18,
                  color: Colors.grey.shade600,
                ),

                const SizedBox(width: 7),

                Text(
                  _formatDate(alert.alertTime),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Recommendation
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: impactColor.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: impactColor.withValues(alpha: 0.18),
                ),
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Icon(
                    Icons.shield_outlined,
                    size: 20,
                    color: impactColor,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      alert.recommendation,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final local = dateTime.toLocal();

    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');

    return '${local.day}/${local.month}/${local.year} '
        '$hour:$minute';
  }
}
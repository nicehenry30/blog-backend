import 'package:flutter/material.dart';

import 'package:mytest_project/features/dashboard/domain/entities/latest_dashboard_signal.dart';
import 'package:mytest_project/features/dashboard/presentation/widgets/signal_value.dart';

class LatestSignalCard extends StatelessWidget {
  final LatestDashboardSignal? signal;

  const LatestSignalCard({super.key, this.signal});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // ==============================================================
    // NO SIGNAL
    // ==============================================================

    if (signal == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.18),
          ),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('No active trading signal available.'),
          ),
        ),
      );
    }

    // ==============================================================
    // DIRECTION
    // ==============================================================

    final bool isBuy = signal!.direction.toUpperCase() == 'BUY';

    final Color directionColor = isBuy ? Colors.green : Colors.red;

    final IconData directionIcon = isBuy
        ? Icons.arrow_upward_rounded
        : Icons.arrow_downward_rounded;

    // ==============================================================
    // CARD
    // ==============================================================

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==========================================================
          // SYMBOL + DIRECTION
          // ==========================================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    signal!.symbol,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    '${signal!.strategy} • ${signal!.timeframe}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.55,
                      ),
                    ),
                  ),
                ],
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: directionColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(directionIcon, color: directionColor, size: 16),

                    const SizedBox(width: 4),

                    Text(
                      signal!.direction,
                      style: TextStyle(
                        color: directionColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // ==========================================================
          // ENTRY / STOP LOSS / TAKE PROFIT
          // ==========================================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SignalValue(
                title: 'Entry',
                value: signal!.entryPrice.toStringAsFixed(2),
              ),

              SignalValue(
                title: 'Stop Loss',
                value: signal!.stopLoss.toStringAsFixed(2),
              ),

              SignalValue(
                title: 'Take Profit',
                value: signal!.takeProfit.toStringAsFixed(2),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Divider(color: theme.colorScheme.outline.withValues(alpha: 0.15)),

          const SizedBox(height: 14),

          // ==========================================================
          // SIGNAL STATUS
          // ==========================================================
          Row(
            children: [
              Icon(
                Icons.radio_button_checked,
                size: 18,
                color: signal!.status.toUpperCase() == 'RUNNING'
                    ? Colors.green
                    : theme.colorScheme.primary,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  'Signal Status',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Text(
                signal!.status,
                style: TextStyle(
                  color: signal!.status.toUpperCase() == 'RUNNING'
                      ? Colors.green
                      : theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ==========================================================
          // STRATEGY
          // ==========================================================
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                size: 20,
                color: theme.colorScheme.primary,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  'Trading Strategy',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Text(
                signal!.strategy,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ==========================================================
          // TIMEFRAME
          // ==========================================================
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Timeframe: ${signal!.timeframe}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

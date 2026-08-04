import 'package:flutter/material.dart';

import 'package:mytest_project/features/dashboard/presentation/widgets/signal_value.dart';

class LatestSignalCard extends StatelessWidget {
  const LatestSignalCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(
            alpha: 0.18,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'XAUUSD',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Gold / US Dollar',
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
                  color: Colors.green.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_upward_rounded,
                      color: Colors.green,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'BUY',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SignalValue(
                title: 'Entry',
                value: '3,350.00',
              ),
              SignalValue(
                title: 'Stop Loss',
                value: '3,335.00',
              ),
              SignalValue(
                title: 'Take Profit',
                value: '3,390.00',
              ),
            ],
          ),

          const SizedBox(height: 20),

          Divider(
            color: theme.colorScheme.outline.withValues(
              alpha: 0.15,
            ),
          ),

          const SizedBox(height: 14),

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
                  'AI Confirmation',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '85/100',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: 0.85,
              minHeight: 7,
              backgroundColor: theme.colorScheme.primary.withValues(
                alpha: 0.10,
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Strong Setup',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../../domain/entities/trading_signal.dart';

import 'confidence_indicator.dart';
import 'confluence_chip.dart';
import 'signal_quality_badge.dart';
import 'signal_status_badge.dart';

class SignalCard extends StatelessWidget {
  final TradingSignal signal;
  final VoidCallback onTap;

  const SignalCard({
    super.key,
    required this.signal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${signal.symbol} ${signal.direction}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SignalStatusBadge(
                    status: signal.status,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              SignalQualityBadge(
                quality: signal.signalQuality,
              ),

              const SizedBox(height: 20),

              ConfidenceIndicator(
                confidence: signal.overallConfidence,
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _PriceTile(
                      label: 'Entry',
                      value: signal.entryPrice.toString(),
                    ),
                  ),
                  Expanded(
                    child: _PriceTile(
                      label: 'SL',
                      value: signal.stopLoss.toString(),
                    ),
                  ),
                  Expanded(
                    child: _PriceTile(
                      label: 'TP',
                      value: signal.takeProfit.toString(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Text(
                'Timeframe',
                style: Theme.of(context).textTheme.titleSmall,
              ),

              const SizedBox(height: 4),

              Text(signal.timeframe),

              if (signal.strategy != null &&
                  signal.strategy!.isNotEmpty) ...[
                const SizedBox(height: 16),

                Text(
                  'Strategy',
                  style:
                      Theme.of(context).textTheme.titleSmall,
                ),

                const SizedBox(height: 4),

                Text(signal.strategy!),
              ],

              const SizedBox(height: 16),

              Text(
                'Confluences',
                style: Theme.of(context).textTheme.titleSmall,
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: signal.confluences
                    .map(
                      (item) => ConfluenceChip(
                        title: item,
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text(
                    'View Details',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriceTile extends StatelessWidget {
  final String label;
  final String value;

  const _PriceTile({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
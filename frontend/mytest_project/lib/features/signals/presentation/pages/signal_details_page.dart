import 'package:flutter/material.dart';

import '../../domain/entities/trading_signal.dart';
import '../widgets/confidence_indicator.dart';
import '../widgets/confluence_chip.dart';
import '../widgets/signal_quality_badge.dart';
import '../widgets/signal_status_badge.dart';

class SignalDetailsPage extends StatelessWidget {
  final TradingSignal signal;

  const SignalDetailsPage({
    super.key,
    required this.signal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(signal.symbol),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SignalStatusBadge(
                status: signal.status,
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                '${signal.symbol} ${signal.direction}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: SignalQualityBadge(
                quality: signal.signalQuality,
              ),
            ),

            const SizedBox(height: 24),

            ConfidenceIndicator(
              confidence: signal.overallConfidence,
            ),

            const SizedBox(height: 24),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _DetailRow(
                      label: 'Entry',
                      value: signal.entryPrice.toString(),
                    ),
                    const Divider(),
                    _DetailRow(
                      label: 'Stop Loss',
                      value: signal.stopLoss.toString(),
                    ),
                    const Divider(),
                    _DetailRow(
                      label: 'Take Profit',
                      value: signal.takeProfit.toString(),
                    ),
                    const Divider(),
                    _DetailRow(
                      label: 'Timeframe',
                      value: signal.timeframe,
                    ),
                  ],
                ),
              ),
            ),

            if (signal.strategy != null &&
                signal.strategy!.isNotEmpty) ...[
              const SizedBox(height: 24),

              Text(
                'Strategy',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge,
              ),

              const SizedBox(height: 10),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(signal.strategy!),
                ),
              ),
            ],

            const SizedBox(height: 24),

            Text(
              'Confluences',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: signal.confluences
                  .map(
                    (e) => ConfluenceChip(
                      title: e,
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 30),

            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade200,
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.candlestick_chart,
                      size: 60,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Chart Preview',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
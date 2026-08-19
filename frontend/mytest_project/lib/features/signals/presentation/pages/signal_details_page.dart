import 'package:flutter/material.dart';

import '../../domain/entities/trading_signal.dart';
import '../widgets/confidence_indicator.dart';
import '../widgets/confluence_chip.dart';
import '../widgets/signal_quality_badge.dart';
import '../widgets/signal_status_badge.dart';
import '../widgets/signal_visibility_badge.dart';
import '../widgets/signal_history_timeline.dart';

class SignalDetailsPage extends StatelessWidget {
  final TradingSignal signal;

  const SignalDetailsPage({super.key, required this.signal});

  @override
  Widget build(BuildContext context) {
    if (signal.locked) {
      return Scaffold(
        appBar: AppBar(title: Text(signal.symbol), centerTitle: true),
        body: _LockedSignalView(signal: signal),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(signal.symbol), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  SignalStatusBadge(status: signal.status),

                  const SizedBox(height: 10),

                  SignalVisibilityBadge(visibility: signal.visibility),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: Text(
                '${signal.symbol} ${signal.direction}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Center(child: SignalQualityBadge(quality: signal.signalQuality)),

            const SizedBox(height: 24),

            ConfidenceIndicator(confidence: signal.overallConfidence),

            const SizedBox(height: 30),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _DetailRow(
                      label: 'Entry',
                      value: signal.entryPrice.toStringAsFixed(signal.digits),
                    ),

                    const Divider(),

                    _DetailRow(
                      label: 'Stop Loss',
                      value: signal.stopLoss.toStringAsFixed(signal.digits),
                    ),

                    const Divider(),

                    _DetailRow(
                      label: 'Take Profit 1',
                      value: signal.takeProfit.toStringAsFixed(signal.digits),
                    ),

                    if (signal.takeProfit2 != null) ...[
                      const Divider(),
                      _DetailRow(
                        label: 'Take Profit 2',
                        value: signal.takeProfit2!.toStringAsFixed(
                          signal.digits,
                        ),
                      ),
                    ],

                    if (signal.takeProfit3 != null) ...[
                      const Divider(),
                      _DetailRow(
                        label: 'Take Profit 3',
                        value: signal.takeProfit3!.toStringAsFixed(
                          signal.digits,
                        ),
                      ),
                    ],

                    const Divider(),

                    _DetailRow(label: 'Timeframe', value: signal.timeframe),
                  ],
                ),
              ),
            ),

            if (signal.strategy != null && signal.strategy!.isNotEmpty) ...[
              const SizedBox(height: 24),

              Text('Strategy', style: Theme.of(context).textTheme.titleLarge),

              const SizedBox(height: 10),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(signal.strategy!),
                ),
              ),
            ],

            if (signal.analysis != null && signal.analysis!.isNotEmpty) ...[
              const SizedBox(height: 24),

              Text(
                'Market Analysis',
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 10),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    signal.analysis!,
                    style: const TextStyle(height: 1.5),
                  ),
                ),
              ),
            ],

            if (signal.aiScore != null || signal.aiComment != null) ...[
              const SizedBox(height: 24),

              Text(
                'AI Confirmation',
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 10),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (signal.aiScore != null) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'AI Score',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),

                            Text(
                              '${signal.aiScore!.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        LinearProgressIndicator(
                          value: signal.aiScore! / 100,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ],

                      if (signal.aiScore != null && signal.aiComment != null)
                        const SizedBox(height: 20),

                      if (signal.aiComment != null &&
                          signal.aiComment!.isNotEmpty) ...[
                        const Text(
                          'AI Comment',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          signal.aiComment!,
                          style: const TextStyle(height: 1.5),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            Text('Confluences', style: Theme.of(context).textTheme.titleLarge),

            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: signal.confluences
                  .map((e) => ConfluenceChip(title: e))
                  .toList(),
            ),

            const SizedBox(height: 30),

            if (signal.chartImageUrl != null &&
                signal.chartImageUrl!.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  signal.chartImageUrl!,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return const SizedBox(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.shade200,
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image, size: 60),
                            SizedBox(height: 12),
                            Text('Unable to load chart'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ] else ...[
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade200,
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.candlestick_chart, size: 60),
                      SizedBox(height: 12),
                      Text('No chart available'),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 10),

            Text(
              'Signal History',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 16),

            SignalHistoryTimeline(histories: signal.histories),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),

          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _LockedSignalView extends StatelessWidget {
  final TradingSignal signal;

  const _LockedSignalView({required this.signal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 90, color: Colors.orange),

            const SizedBox(height: 24),

            Text(
              '${signal.upgradePlan} Signal',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            const Text(
              'Upgrade your subscription to unlock this trading signal.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: const [
                    ListTile(
                      leading: Icon(Icons.check_circle),
                      title: Text('Entry Price'),
                    ),

                    ListTile(
                      leading: Icon(Icons.check_circle),
                      title: Text('Stop Loss'),
                    ),

                    ListTile(
                      leading: Icon(Icons.check_circle),
                      title: Text('Take Profit Targets'),
                    ),

                    ListTile(
                      leading: Icon(Icons.check_circle),
                      title: Text('Chart Analysis'),
                    ),

                    ListTile(
                      leading: Icon(Icons.check_circle),
                      title: Text('AI Explanation'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to subscription page
                },
                child: Text('Upgrade to ${signal.upgradePlan}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

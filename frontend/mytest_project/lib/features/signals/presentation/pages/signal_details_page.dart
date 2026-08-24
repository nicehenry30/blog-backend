import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/ai_signal_confirmation.dart';
import '../../domain/entities/trading_signal.dart';
import '../bloc/trading_signal_bloc.dart';

class SignalDetailsPage extends StatefulWidget {
  final TradingSignal signal;

  const SignalDetailsPage({
    super.key,
    required this.signal,
  });

  @override
  State<SignalDetailsPage> createState() => _SignalDetailsPageState();
}

class _SignalDetailsPageState extends State<SignalDetailsPage> {
  @override
  void initState() {
    super.initState();

    context.read<TradingSignalBloc>().add(
          LoadAiSignalConfirmation(widget.signal.id),
        );
  }

  @override
  Widget build(BuildContext context) {
    final signal = widget.signal;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Trading Signal',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: signal.locked
          ? _buildLockedView(context, signal)
          : _buildSignalDetails(context, signal),
    );
  }

  // ============================================================
  // LOCKED SIGNAL
  // ============================================================

  Widget _buildLockedView(
    BuildContext context,
    TradingSignal signal,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSignalHeader(signal),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 56,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Premium Signal',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'This trading signal is available only to subscribers on the required plan.',
                    textAlign: TextAlign.center,
                  ),
                  if (signal.upgradePlan != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Upgrade to ${signal.upgradePlan}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MAIN DETAILS
  // ============================================================

  Widget _buildSignalDetails(
    BuildContext context,
    TradingSignal signal,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSignalHeader(signal),

          const SizedBox(height: 16),

          _buildPriceCard(signal),

          const SizedBox(height: 16),

          _buildConfidenceCard(signal),

          const SizedBox(height: 16),

          _buildStrategyCard(signal),

          const SizedBox(height: 16),

          _buildAnalysisCard(signal),

          const SizedBox(height: 16),

          _buildAiConfirmationSection(),

          const SizedBox(height: 16),

          _buildHistorySection(signal),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ============================================================
  // SIGNAL HEADER
  // ============================================================

  Widget _buildSignalHeader(TradingSignal signal) {
    final isBuy = signal.direction.toUpperCase() == 'BUY';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        signal.symbol,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        signal.symbolName,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                _directionBadge(
                  signal.direction,
                  isBuy,
                ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: _infoItem(
                    'Timeframe',
                    signal.timeframe,
                  ),
                ),
                Expanded(
                  child: _infoItem(
                    'Status',
                    signal.status,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _infoItem(
                    'Asset',
                    signal.assetType,
                  ),
                ),
                Expanded(
                  child: _infoItem(
                    'Visibility',
                    signal.visibility,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _directionBadge(
    String direction,
    bool isBuy,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isBuy
            ? Colors.green.withValues(alpha: 0.12)
            : Colors.red.withValues(alpha: 0.12),
      ),
      child: Text(
        direction,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isBuy ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  // ============================================================
  // PRICE CARD
  // ============================================================

  Widget _buildPriceCard(TradingSignal signal) {
    return _sectionCard(
      title: 'Trade Levels',
      icon: Icons.price_change_outlined,
      child: Column(
        children: [
          _priceRow(
            'Entry',
            signal.entryPrice,
          ),
          const Divider(),
          _priceRow(
            'Stop Loss',
            signal.stopLoss,
          ),
          const Divider(),
          _priceRow(
            'Take Profit 1',
            signal.takeProfit,
          ),
          if (signal.takeProfit2 != null) ...[
            const Divider(),
            _priceRow(
              'Take Profit 2',
              signal.takeProfit2!,
            ),
          ],
          if (signal.takeProfit3 != null) ...[
            const Divider(),
            _priceRow(
              'Take Profit 3',
              signal.takeProfit3!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _priceRow(
    String label,
    double value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONFIDENCE
  // ============================================================

  Widget _buildConfidenceCard(
    TradingSignal signal,
  ) {
    return _sectionCard(
      title: 'Signal Confidence',
      icon: Icons.analytics_outlined,
      child: Column(
        children: [
          _percentageRow(
            'Signal Quality',
            signal.signalQuality,
          ),
          const SizedBox(height: 18),
          _percentageRow(
            'Overall Confidence',
            signal.overallConfidence,
          ),
        ],
      ),
    );
  }

  Widget _percentageRow(
    String label,
    double value,
  ) {
    final percentage = value > 1 ? value : value * 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (percentage / 100).clamp(0.0, 1.0),
        ),
      ],
    );
  }

  // ============================================================
  // STRATEGY
  // ============================================================

  Widget _buildStrategyCard(
    TradingSignal signal,
  ) {
    return _sectionCard(
      title: 'Strategy & Confluences',
      icon: Icons.auto_graph,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (signal.strategy != null) ...[
            const Text(
              'Strategy',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(signal.strategy!),
            const SizedBox(height: 18),
          ],

          const Text(
            'Confluences',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          if (signal.confluences.isEmpty)
            const Text('No confluences available.')
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: signal.confluences
                  .map(
                    (item) => Chip(
                      label: Text(item),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // ANALYSIS
  // ============================================================

  Widget _buildAnalysisCard(
    TradingSignal signal,
  ) {
    if (signal.analysis == null ||
        signal.analysis!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return _sectionCard(
      title: 'Market Analysis',
      icon: Icons.article_outlined,
      child: Text(
        signal.analysis!,
        style: const TextStyle(
          height: 1.5,
        ),
      ),
    );
  }

  // ============================================================
  // AI CONFIRMATION
  // ============================================================

  Widget _buildAiConfirmationSection() {
    return BlocBuilder<
        TradingSignalBloc,
        TradingSignalState>(
      builder: (context, state) {
        if (state is AiSignalConfirmationLoading) {
          return _sectionCard(
            title: 'AI Historical Confirmation',
            icon: Icons.psychology_outlined,
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        if (state is AiSignalConfirmationFailure) {
          return _sectionCard(
            title: 'AI Historical Confirmation',
            icon: Icons.psychology_outlined,
            child: Text(
              state.message,
            ),
          );
        }

        if (state is AiSignalConfirmationLoaded) {
          return _buildAiConfirmationCard(
            state.confirmation,
          );
        }

        return _sectionCard(
          title: 'AI Historical Confirmation',
          icon: Icons.psychology_outlined,
          child: const Text(
            'AI historical confirmation is not available yet.',
          ),
        );
      },
    );
  }

  Widget _buildAiConfirmationCard(
    AiSignalConfirmation confirmation,
  ) {
    return _sectionCard(
      title: 'AI Historical Confirmation',
      icon: Icons.psychology_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (confirmation.score != null)
            _aiScoreCard(
              confirmation.score!,
            ),

          const SizedBox(height: 18),

          _statGrid(
            confirmation,
          ),

          const SizedBox(height: 18),

          _tpSuccessRates(
            confirmation,
          ),

          const SizedBox(height: 18),

          _evidenceRow(
            confirmation,
          ),

          if (confirmation.review != null) ...[
            const SizedBox(height: 20),
            const Text(
              'AI Review',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              confirmation.review!,
              style: const TextStyle(
                height: 1.5,
              ),
            ),
          ],

          if (confirmation.comment != null) ...[
            const SizedBox(height: 20),
            const Text(
              'AI Comment',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              confirmation.comment!,
              style: const TextStyle(
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _aiScoreCard(double score) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .outlineVariant,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Historical AI Score',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${score.toStringAsFixed(1)}%',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statGrid(
    AiSignalConfirmation confirmation,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.2,
      children: [
        _statTile(
          'Sample Size',
          confirmation.sampleSize.toString(),
        ),
        _statTile(
          'Wins',
          confirmation.wins.toString(),
        ),
        _statTile(
          'Losses',
          confirmation.losses.toString(),
        ),
        _statTile(
          'Breakevens',
          confirmation.breakevens.toString(),
        ),
        _statTile(
          'Average Pips',
          confirmation.averagePips.toStringAsFixed(1),
        ),
      ],
    );
  }

  Widget _statTile(
    String label,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .outlineVariant,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 3),
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

  Widget _tpSuccessRates(
    AiSignalConfirmation confirmation,
  ) {
    return Column(
      children: [
        _percentageRow(
          'TP1 Success',
          confirmation.tp1SuccessRate,
        ),
        const SizedBox(height: 14),
        _percentageRow(
          'TP2 Success',
          confirmation.tp2SuccessRate,
        ),
        const SizedBox(height: 14),
        _percentageRow(
          'TP3 Success',
          confirmation.tp3SuccessRate,
        ),
      ],
    );
  }

  Widget _evidenceRow(
    AiSignalConfirmation confirmation,
  ) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Evidence Level',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Chip(
          label: Text(
            confirmation.evidenceLevel.toUpperCase(),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // HISTORY
  // ============================================================

 Widget _buildHistorySection(
  TradingSignal signal,
) {
  return _sectionCard(
    title: 'Signal History',
    icon: Icons.history,
    child: signal.histories.isEmpty
        ? const Text(
            'No signal history available.',
          )
        : Column(
            children: signal.histories.map(
              (history) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 18,
                  ),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(
                            width: 2,
                            height: 70,
                          ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              history.event,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              history.description,
                              style: const TextStyle(
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (history.oldStatus != null ||
                                history.newStatus != null)
                              Row(
                                children: [
                                  if (history.oldStatus != null)
                                    Expanded(
                                      child: _historyStatus(
                                        'From',
                                        history.oldStatus!,
                                      ),
                                    ),
                                  if (history.newStatus != null)
                                    Expanded(
                                      child: _historyStatus(
                                        'To',
                                        history.newStatus!,
                                      ),
                                    ),
                                ],
                              ),
                            const SizedBox(height: 8),
                            Text(
                              _formatHistoryDate(
                                history.createdAt,
                              ),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
          ),
  );
}
  Widget _historyStatus(
  String label,
  String status,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey.shade600,
        ),
      ),
      const SizedBox(height: 2),
      Text(
        status,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

String _formatHistoryDate(
  DateTime date,
) {
  final localDate = date.toLocal();

  final day = localDate.day.toString().padLeft(2, '0');
  final month = localDate.month.toString().padLeft(2, '0');
  final year = localDate.year.toString();

  final hour = localDate.hour.toString().padLeft(2, '0');
  final minute = localDate.minute.toString().padLeft(2, '0');

  return '$day/$month/$year • $hour:$minute';
}
  // ============================================================
  // COMMON UI
  // ============================================================

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _infoItem(
    String label,
    String value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 3),
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
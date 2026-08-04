
import 'package:flutter/material.dart';

import 'package:mytest_project/features/journal/domain/entities/trade.dart';
import 'package:mytest_project/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:mytest_project/features/journal/presentation/pages/edit_trade_page.dart';


class TradeDetailsPage extends StatelessWidget {
  final Trade trade;
  final JournalBloc journalBloc;

  const TradeDetailsPage({
    super.key,
    required this.trade,
    required this.journalBloc,
  });

  @override
  Widget build(BuildContext context) {
    final bool isBuy = trade.direction == 'BUY';
    final bool isWin = trade.isWin;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trade Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ================================================================
            // TRADE HEADER
            // ================================================================

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    Text(
                      trade.symbol,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _StatusBadge(
                          label: trade.direction,
                          icon: isBuy
                              ? Icons.trending_up
                              : Icons.trending_down,
                          color: isBuy
                              ? Colors.green
                              : Colors.red,
                        ),

                        const SizedBox(width: 12),

                        _StatusBadge(
                          label: trade.result,
                          icon: isWin
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: isWin
                              ? Colors.green
                              : Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ================================================================
            // PRICE INFORMATION
            // ================================================================

            const Text(
              'Price Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    _DetailRow(
                      label: 'Entry Price',
                      value: trade.entry.toString(),
                    ),

                    const Divider(height: 24),

                    _DetailRow(
                      label: 'Exit Price',
                      value: trade.exit.toString(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ================================================================
            // PROFIT / LOSS
            // ================================================================

            const Text(
              'Performance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: _DetailRow(
                  label: 'Profit / Loss',
                  value:
                      '${trade.profitLoss >= 0 ? '+' : ''}${trade.profitLoss.toStringAsFixed(2)}',
                  valueColor: isWin
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ================================================================
            // NOTES
            // ================================================================

            const Text(
              'Notes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Text(
                  trade.notes.isEmpty
                      ? 'No notes added for this trade.'
                      : trade.notes,

                  style: TextStyle(
                    fontSize: 15,
                    color: trade.notes.isEmpty
                        ? Colors.grey
                        : null,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ================================================================
            // EDIT TRADE BUTTON
            // ================================================================

           // ================================================================
// EDIT TRADE BUTTON
// ================================================================

SizedBox(
  height: 52,
  child: ElevatedButton.icon(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditTradePage(
            trade: trade,
            journalBloc: journalBloc,
          ),
        ),
      );
    },
    icon: const Icon(Icons.edit),
    label: const Text(
      'Edit Trade',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),

const SizedBox(height: 16),

// ================================================================
// DELETE TRADE BUTTON
// ================================================================

SizedBox(
  height: 52,
  child: OutlinedButton.icon(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: Colors.red),
      foregroundColor: Colors.red,
    ),
    icon: const Icon(Icons.delete_outline),
    label: const Text(
      'Delete Trade',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
    onPressed: () async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Delete Trade'),
            content: const Text(
              'Are you sure you want to delete this trade?\n\nThis action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext, false);
                },
                child: const Text('Cancel'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  Navigator.pop(dialogContext, true);
                },
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );

      if (confirmed == true && trade.id != null) {
  journalBloc.add(
    JournalDeleteTrade(trade.id!),
  );

  await Future.delayed(
    const Duration(milliseconds: 300),
  );

  if (context.mounted) {
    Navigator.pop(context);
  }
}
    },
  ),
),

const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// STATUS BADGE
// ============================================================================

class _StatusBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _StatusBadge({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),

      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: color,
          ),

          const SizedBox(width: 6),

          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// DETAIL ROW
// ============================================================================

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),

        const SizedBox(width: 20),

        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,

            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }
}


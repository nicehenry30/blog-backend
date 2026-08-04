
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mytest_project/features/journal/domain/entities/trade.dart';
import 'package:mytest_project/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:mytest_project/features/journal/presentation/pages/trade_details_page.dart';

class AllTradesPage extends StatelessWidget {
  const AllTradesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Trades',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: BlocBuilder<JournalBloc, JournalState>(
        builder: (context, state) {
          // ================================================================
          // LOADING
          // ================================================================

          if (state is JournalInitial || state is JournalLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ================================================================
          // FAILURE
          // ================================================================

          if (state is JournalFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // ================================================================
          // LOADED
          // ================================================================

          if (state is JournalLoaded) {
            if (state.trades.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu_book_outlined,
                      size: 64,
                    ),

                    SizedBox(height: 16),

                    Text(
                      'No trades found.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<JournalBloc>().add(
                  const JournalLoadTrades(),
                );
              },

              child: ListView.separated(
                padding: const EdgeInsets.all(16),

                itemCount: state.trades.length,

                separatorBuilder: (_, _) {
                  return const SizedBox(height: 12);
                },

                itemBuilder: (context, index) {
                  final trade = state.trades[index];

                  return _AllTradeCard(
                    trade: trade,
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ============================================================================
// ALL TRADE CARD
// ============================================================================

class _AllTradeCard extends StatelessWidget {
  final Trade trade;

  const _AllTradeCard({
    required this.trade,
  });

  @override
  Widget build(BuildContext context) {
    final isBuy = trade.direction == 'BUY';
    final isWin = trade.isWin;

    return Card(
      child: InkWell(
        // ================================================================
        // OPEN TRADE DETAILS
        // ================================================================

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TradeDetailsPage(
                trade: trade,
                journalBloc: context.read<JournalBloc>(),
              ),
            ),
          );
        },

        borderRadius: BorderRadius.circular(12),

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [
              // ============================================================
              // SYMBOL + DIRECTION
              // ============================================================

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    trade.symbol,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),

                    decoration: BoxDecoration(
                      color: isBuy
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),

                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Text(
                      trade.direction,
                      style: TextStyle(
                        color: isBuy
                            ? Colors.green
                            : Colors.red,

                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ============================================================
              // ENTRY / EXIT / RESULT
              // ============================================================

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _TradeValue(
                    label: 'Entry',
                    value: trade.entry.toString(),
                  ),

                  _TradeValue(
                    label: 'Exit',
                    value: trade.exit.toString(),
                  ),

                  _TradeValue(
                    label: 'Result',
                    value: trade.result,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ============================================================
              // PROFIT / LOSS
              // ============================================================

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Profit / Loss',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    '${trade.profitLoss >= 0 ? '+' : ''}£${trade.profitLoss.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: isWin
                          ? Colors.green
                          : Colors.red,

                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// TRADE VALUE
// ============================================================================

class _TradeValue extends StatelessWidget {
  final String label;
  final String value;

  const _TradeValue({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mytest_project/features/journal/domain/entities/trade.dart';
import 'package:mytest_project/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:mytest_project/features/journal/presentation/pages/all_trades_page.dart';
import 'package:mytest_project/features/journal/presentation/pages/trade_details_page.dart';
import 'package:mytest_project/features/settings/presentation/pages/settings_page.dart';


// Import the AddTradePage from the same file (it's defined below)
// No import needed since it's in the same file

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trading Journal',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Add journal filter functionality.
            },
          ),
        ],
      ),

      // =========================================================================
      // ADD TRADE BUTTON
      // =========================================================================
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final Trade? newTrade = await Navigator.push<Trade>(
            context,
            MaterialPageRoute(
              builder: (_) => const AddTradePage(),
            ),
          );

          if (newTrade != null && context.mounted) {
            context.read<JournalBloc>().add(
                  JournalAddTrade(newTrade),
                );
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Trade'),
      ),

      // =========================================================================
      // JOURNAL BLOC
      // =========================================================================
      body: BlocBuilder<JournalBloc, JournalState>(
        builder: (context, state) {
          if (state is JournalInitial || state is JournalLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is JournalFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            );
          }

          if (state is JournalLoaded) {
            return _JournalContent(
              trades: state.trades,
              theme: theme,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ============================================================================
// JOURNAL CONTENT
// ============================================================================

class _JournalContent extends StatelessWidget {
  final List<Trade> trades;
  final ThemeData theme;

  const _JournalContent({
    required this.trades,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    // =========================================================================
    // CALCULATED STATISTICS
    // =========================================================================

    final totalTrades = trades.length;

    final winningTrades = trades
        .where((trade) => trade.isWin)
        .length;

    final losingTrades = trades
        .where((trade) => trade.isLoss)
        .length;

    final winRate = totalTrades == 0
        ? 0.0
        : (winningTrades / totalTrades) * 100;

    final totalProfitLoss = trades.fold<double>(
      0.0,
      (total, trade) => total + trade.profitLoss,
    );

    final isProfitable = totalProfitLoss >= 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =====================================================================
          // PERFORMANCE OVERVIEW
          // =====================================================================

          Text(
            'Performance Overview',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Total Trades',
                  value: '$totalTrades',
                  icon: Icons.bar_chart,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _StatCard(
                  title: 'Win Rate',
                  value: '${winRate.toStringAsFixed(1)}%',
                  icon: Icons.trending_up,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Winning',
                  value: '$winningTrades',
                  icon: Icons.check_circle_outline,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _StatCard(
                  title: 'Losing',
                  value: '$losingTrades',
                  icon: Icons.cancel_outlined,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ProfitLossCard(
            totalProfitLoss: totalProfitLoss,
            isProfitable: isProfitable,
          ),

          const SizedBox(height: 32),

          // =====================================================================
          // RECENT TRADES
          // =====================================================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Trades',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              TextButton(
                onPressed: () {
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<JournalBloc>(),
                        child: const AllTradesPage(),
                      ),
                    ),
                  );
                  
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (trades.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.menu_book_outlined,
                        size: 48,
                      ),

                      SizedBox(height: 12),

                      Text(
                        'No trades in your journal yet.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 6),

                      Text(
                        'Tap "Add Trade" to record your first trade.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            ...trades
                .take(5)
                .map(
                  (trade) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: _TradeCard(
                      trade: trade,
                    ),
                  ),
                ),

          const SizedBox(height: 32),

          // =====================================================================
          // TRADING PSYCHOLOGY
          // =====================================================================

          Text(
            'Trading Psychology',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.psychology_outlined,
                        color: theme.colorScheme.primary,
                      ),

                      const SizedBox(width: 10),

                      const Text(
                        'Your Trading Mindset',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Discipline',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  LinearProgressIndicator(
                    value: 0.80,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Emotional Control',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  LinearProgressIndicator(
                    value: 0.70,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Risk Management',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  LinearProgressIndicator(
                    value: 0.90,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // =====================================================================
          // JOURNAL INSIGHT
          // =====================================================================

          Text(
            'Journal Insight',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: Colors.orange.shade700,
                    size: 28,
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Text(
                      'Your winning trades are performing better when you follow your trading plan and avoid overtrading. Keep focusing on disciplined setups.',
                      style: TextStyle(
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// STAT CARD
// ============================================================================

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 24,
            ),

            const SizedBox(height: 12),

            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// PROFIT / LOSS CARD
// ============================================================================

class _ProfitLossCard extends StatelessWidget {
  final double totalProfitLoss;
  final bool isProfitable;

  const _ProfitLossCard({
    required this.totalProfitLoss,
    required this.isProfitable,
  });

  @override
  Widget build(BuildContext context) {
    final profitLossText =
        '${isProfitable ? '+' : ''}£${totalProfitLoss.toStringAsFixed(2)}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: (isProfitable
                        ? Colors.green
                        : Colors.red)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.account_balance_wallet_outlined,
                color: isProfitable
                    ? Colors.green
                    : Colors.red,
                size: 26,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Profit / Loss',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    profitLossText,
                    style: TextStyle(
                      color: isProfitable
                          ? Colors.green
                          : Colors.red,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              isProfitable
                  ? Icons.trending_up
                  : Icons.trending_down,
              color: isProfitable
                  ? Colors.green
                  : Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// TRADE CARD
// ============================================================================

class _TradeCard extends StatelessWidget {
  final Trade trade;

  const _TradeCard({
    required this.trade,
  });

  @override
  Widget build(BuildContext context) {
    final isBuy = trade.direction == 'BUY';

    return Card(
      child: InkWell(
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
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
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
                      borderRadius:
                          BorderRadius.circular(20),
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

              const SizedBox(height: 14),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  _TradeInfo(
                    label: 'Entry',
                    value: trade.entry.toString(),
                  ),

                  _TradeInfo(
                    label: 'Exit',
                    value: trade.exit.toString(),
                  ),

                  _TradeInfo(
                    label: 'Result',
                    value: trade.result,
                  ),

                  Text(
                    '${trade.profitLoss >= 0 ? '+' : ''}${trade.profitLoss.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: trade.isWin
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
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
// TRADE INFO
// ============================================================================

class _TradeInfo extends StatelessWidget {
  final String label;
  final String value;

  const _TradeInfo({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
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
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// ADD TRADE PAGE
// ============================================================================

class AddTradePage extends StatefulWidget {
  const AddTradePage({
    super.key,
  });

  @override
  State<AddTradePage> createState() =>
      _AddTradePageState();
}

class _AddTradePageState
    extends State<AddTradePage> {
  final _formKey =
      GlobalKey<FormState>();

  final _symbolController =
      TextEditingController();

  final _entryController =
      TextEditingController();

  final _exitController =
      TextEditingController();

  final _profitLossController =
      TextEditingController();

  final _notesController =
      TextEditingController();

  String _direction = 'BUY';
  String _result = 'WIN';

  @override
  void dispose() {
    _symbolController.dispose();
    _entryController.dispose();
    _exitController.dispose();
    _profitLossController.dispose();
    _notesController.dispose();

    super.dispose();
  }

  // ==========================================================================
  // SAVE TRADE
  // ==========================================================================

  void _saveTrade() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final entry =
        double.tryParse(
      _entryController.text.trim(),
    );

    final exit =
        double.tryParse(
      _exitController.text.trim(),
    );

    final profitLoss =
        double.tryParse(
      _profitLossController.text.trim(),
    );

    if (entry == null ||
        exit == null ||
        profitLoss == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter valid numerical values.',
          ),
        ),
      );

      return;
    }

    final trade = Trade(
      symbol: _symbolController.text
          .trim()
          .toUpperCase(),
      direction: _direction,
      entry: entry,
      exit: exit,
      result: _result,
      profitLoss: profitLoss,
      notes: _notesController.text.trim(),
    );

    Navigator.pop(
      context,
      trade,
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Trade',
        ),
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // =================================================================
              // SYMBOL
              // =================================================================

              TextFormField(
                controller:
                    _symbolController,
                textCapitalization:
                    TextCapitalization.characters,
                decoration:
                    const InputDecoration(
                  labelText: 'Symbol',
                  hintText: 'e.g. XAUUSD',
                  prefixIcon: Icon(
                    Icons.currency_exchange,
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Enter the trading symbol';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // =================================================================
              // DIRECTION
              // =================================================================

              DropdownButtonFormField<String>(
                initialValue: _direction,
                decoration:
                    const InputDecoration(
                  labelText: 'Direction',
                  prefixIcon: Icon(
                    Icons.swap_vert,
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'BUY',
                    child: Text('BUY'),
                  ),
                  DropdownMenuItem(
                    value: 'SELL',
                    child: Text('SELL'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _direction =
                          value;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              // =================================================================
              // ENTRY
              // =================================================================

              TextFormField(
                controller:
                    _entryController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration:
                    const InputDecoration(
                  labelText: 'Entry Price',
                  prefixIcon: Icon(
                    Icons.login,
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Enter the entry price';
                  }

                  if (double.tryParse(
                        value.trim(),
                      ) ==
                      null) {
                    return 'Enter a valid number';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // =================================================================
              // EXIT
              // =================================================================

              TextFormField(
                controller:
                    _exitController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration:
                    const InputDecoration(
                  labelText: 'Exit Price',
                  prefixIcon: Icon(
                    Icons.logout,
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Enter the exit price';
                  }

                  if (double.tryParse(
                        value.trim(),
                      ) ==
                      null) {
                    return 'Enter a valid number';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // =================================================================
              // RESULT
              // =================================================================

              DropdownButtonFormField<String>(
                initialValue: _result,
                decoration:
                    const InputDecoration(
                  labelText: 'Result',
                  prefixIcon: Icon(
                    Icons.assessment_outlined,
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'WIN',
                    child: Text('WIN'),
                  ),
                  DropdownMenuItem(
                    value: 'LOSS',
                    child: Text('LOSS'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _result =
                          value;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              // =================================================================
              // PROFIT / LOSS
              // =================================================================

              TextFormField(
                controller:
                    _profitLossController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration:
                    const InputDecoration(
                  labelText:
                      'Profit / Loss',
                  hintText:
                      'e.g. 50 or -20',
                  prefixIcon: Icon(
                    Icons.account_balance_wallet_outlined,
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Enter your profit or loss';
                  }

                  if (double.tryParse(
                        value.trim(),
                      ) ==
                      null) {
                    return 'Enter a valid number';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // =================================================================
              // NOTES
              // =================================================================

              TextFormField(
                controller:
                    _notesController,
                maxLines: 4,
                decoration:
                    const InputDecoration(
                  labelText:
                      'Trade Notes',
                  hintText:
                      'How did you feel? What did you learn?',
                  prefixIcon: Icon(
                    Icons.notes,
                  ),
                  alignLabelWithHint:
                      true,
                ),
              ),

              const SizedBox(height: 32),

              // =================================================================
              // SAVE BUTTON
              // =================================================================

              SizedBox(
                width: double.infinity,
                height: 52,
                child:
                    ElevatedButton.icon(
                  onPressed:
                      _saveTrade,
                  icon: const Icon(
                    Icons.save_outlined,
                  ),
                  label: const Text(
                    'Save Trade',
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
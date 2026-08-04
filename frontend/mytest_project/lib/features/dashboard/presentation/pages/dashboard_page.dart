import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mytest_project/core/di/injection_container.dart';
import 'package:mytest_project/features/dashboard/presentation/bloc/dashboard_bloc.dart';

import 'package:mytest_project/features/dashboard/presentation/widgets/account_card.dart';
import 'package:mytest_project/features/dashboard/presentation/widgets/guardian_card.dart';
import 'package:mytest_project/features/dashboard/presentation/widgets/latest_signal_card.dart';
import 'package:mytest_project/features/dashboard/presentation/widgets/quick_action_card.dart';
import 'package:mytest_project/features/dashboard/presentation/widgets/risk_card.dart';
import 'package:mytest_project/features/dashboard/presentation/widgets/section_header.dart';
import 'package:mytest_project/features/dashboard/presentation/widgets/subscription_card.dart';
import 'package:mytest_project/features/dashboard/presentation/widgets/welcome_header.dart';
import 'package:mytest_project/features/signals/presentation/pages/signals_page.dart';
import 'package:mytest_project/features/risk_settings/presentation/pages/risk_settings_page.dart';
import 'package:mytest_project/features/guardian/presentation/pages/guardian_page.dart';

class DashboardPage extends StatelessWidget {
  final String name;
  final String email;

  const DashboardPage({super.key, required this.name, required this.email});

  void _openSignalsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignalsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<DashboardBloc>()..add(DashboardLoadRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Tradewisser',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                // TODO: Open notifications page.
              },
              icon: const Icon(Icons.notifications_outlined),
            ),
            const SizedBox(width: 8),
          ],
        ),

        // ==================================================================
        // DASHBOARD BLOC
        // ==================================================================
        body: SafeArea(
          child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              // ============================================================
              // LOADING
              // ============================================================

              if (state is DashboardLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              // ============================================================
              // FAILURE
              // ============================================================

              if (state is DashboardFailure) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48),
                        const SizedBox(height: 16),
                        Text(state.message, textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<DashboardBloc>().add(
                              DashboardLoadRequested(),
                            );
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // ============================================================
              // LOADED
              // ============================================================

              if (state is DashboardLoaded) {
                final stats = state.dashboard.stats;
                final risk = state.dashboard.risk;

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<DashboardBloc>().add(DashboardLoadRequested());
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ==================================================
                        // WELCOME HEADER
                        // ==================================================
                        WelcomeHeader(name: name),

                        const SizedBox(height: 24),

                        // ==================================================
                        // SUBSCRIPTION
                        // ==================================================
                        SubscriptionCard(
                          onTap: () {
                            // TODO: Open subscription page.
                          },
                        ),

                        const SizedBox(height: 32),

                        // ==================================================
                        // TRADING PERFORMANCE
                        // ==================================================
                        const SectionHeader(
                          title: 'Trading Performance',
                          icon: Icons.insights_outlined,
                        ),

                        const SizedBox(height: 12),

                        _DashboardStatsCard(
                          totalProfit: stats.totalProfit,
                          totalTrades: stats.totalTrades,
                          winningTrades: stats.winningTrades,
                          losingTrades: stats.losingTrades,
                          winRate: stats.winRate,
                        ),

                        const SizedBox(height: 32),

                        // ==================================================
                        // LATEST SIGNAL
                        // ==================================================
                        const SectionHeader(
                          title: 'Latest Trading Signal',
                          icon: Icons.candlestick_chart_outlined,
                        ),

                        const SizedBox(height: 12),

                        const LatestSignalCard(),

                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _openSignalsPage(context);
                            },
                            icon: const Icon(Icons.show_chart),
                            label: const Text('View All Signals'),
                          ),
                        ),

                        const SizedBox(height: 32),
                        // ==================================================
                        // RISK OVERVIEW
                        // ==================================================
                        const SectionHeader(
                          title: 'Risk Overview',
                          icon: Icons.security_outlined,
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: RiskCard(
                                title: 'Risk / Trade',
                                value:
                                    '${risk.riskPerTrade.toStringAsFixed(1)}%',
                                icon: Icons.percent,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const RiskSettingsPage(),
                                    ),
                                  );

                                  if (!context.mounted) return;

                                  context.read<DashboardBloc>().add(
                                    DashboardLoadRequested(),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: RiskCard(
                                title: 'Daily Loss',
                                value:
                                    '${risk.dailyLossLimit.toStringAsFixed(1)}%',
                                icon: Icons.trending_down,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const RiskSettingsPage(),
                                    ),
                                  );

                                  if (!context.mounted) return;

                                  context.read<DashboardBloc>().add(
                                    DashboardLoadRequested(),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: RiskCard(
                                title: 'Drawdown',
                                value:
                                    '${risk.maxDrawdown.toStringAsFixed(1)}%',
                                icon: Icons.warning_amber_rounded,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const RiskSettingsPage(),
                                    ),
                                  );

                                  if (!context.mounted) return;

                                  context.read<DashboardBloc>().add(
                                    DashboardLoadRequested(),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // ==================================================
                        // GUARDIAN STATUS
                        // ==================================================
                        const SectionHeader(
                          title: 'Guardian Status',
                          icon: Icons.shield_outlined,
                        ),

                        const SizedBox(height: 12),

                        GuardianCard(
                          platform: 'MT4 Guardian',
                          status: 'Not Connected',
                          icon: Icons.shield_outlined,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const GuardianPage(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 12),

                        GuardianCard(
                          platform: 'MT5 Guardian',
                          status: 'Not Connected',
                          icon: Icons.shield_outlined,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const GuardianPage(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 32),

                        // ==================================================
                        // QUICK ACTIONS
                        // ==================================================
                        const SectionHeader(
                          title: 'Quick Actions',
                          icon: Icons.bolt_outlined,
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: QuickActionCard(
                                title: 'Connect MT4',
                                subtitle: 'MetaTrader 4',
                                icon: Icons.link,
                                onTap: () {
                                  // TODO: Connect MT4.
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: QuickActionCard(
                                title: 'Connect MT5',
                                subtitle: 'MetaTrader 5',
                                icon: Icons.link,
                                onTap: () {
                                  // TODO: Connect MT5.
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // ==================================================
                        // ACCOUNT
                        // ==================================================
                        const SectionHeader(
                          title: 'Account',
                          icon: Icons.person_outline,
                        ),

                        const SizedBox(height: 12),

                        AccountCard(name: name, email: email),
                      ],
                    ),
                  ),
                );
              }

              // ============================================================
              // INITIAL
              // ============================================================

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// DASHBOARD STATS CARD
// ============================================================================

class _DashboardStatsCard extends StatelessWidget {
  final int totalTrades;
  final int winningTrades;
  final int losingTrades;
  final double winRate;
  final double totalProfit;

  const _DashboardStatsCard({
    required this.totalTrades,
    required this.winningTrades,
    required this.losingTrades,
    required this.winRate,
    required this.totalProfit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bool isProfit = totalProfit >= 0;

    final Color profitColor = isProfit
        ? Colors.green.shade600
        : Colors.red.shade600;

    final double safeWinRate = winRate.clamp(0.0, 100.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================================================================
          // PROFIT / LOSS
          // ================================================================
          Text(
            'Total P/L',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.60),
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: profitColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isProfit
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  color: profitColor,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  '${isProfit ? '+' : '-'}\$${totalProfit.abs().toStringAsFixed(2)}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: profitColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Divider(color: theme.colorScheme.outline.withValues(alpha: 0.15)),

          const SizedBox(height: 18),

          // ================================================================
          // STATS
          // ================================================================
          Row(
            children: [
              Expanded(
                child: _PerformanceItem(
                  icon: Icons.receipt_long_outlined,
                  title: 'Trades',
                  value: totalTrades.toString(),
                ),
              ),
              Expanded(
                child: _PerformanceItem(
                  icon: Icons.check_circle_outline,
                  title: 'Wins',
                  value: winningTrades.toString(),
                ),
              ),
              Expanded(
                child: _PerformanceItem(
                  icon: Icons.cancel_outlined,
                  title: 'Losses',
                  value: losingTrades.toString(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ================================================================
          // WIN RATE
          // ================================================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Win Rate',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${winRate.toStringAsFixed(1)}%',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: safeWinRate / 100,
              minHeight: 8,
              backgroundColor: theme.colorScheme.primary.withValues(
                alpha: 0.10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PERFORMANCE ITEM
// ============================================================================

class _PerformanceItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _PerformanceItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 21, color: theme.colorScheme.primary),
        ),

        const SizedBox(height: 8),

        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.60),
          ),
        ),
      ],
    );
  }
}

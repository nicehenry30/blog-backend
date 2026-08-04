import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mytest_project/core/di/injection_container.dart';
import 'package:mytest_project/features/guardian/domain/entities/guardian_account.dart';
import 'package:mytest_project/features/guardian/presentation/bloc/guardian_bloc.dart';

class GuardianPage extends StatelessWidget {
  const GuardianPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<GuardianBloc>()
        ..add(GuardianLoadRequested()),
      child: const _GuardianView(),
    );
  }
}

class _GuardianView extends StatelessWidget {
  const _GuardianView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account Guardian',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<GuardianBloc, GuardianState>(
        builder: (context, state) {
          if (state is GuardianLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is GuardianDisconnecting) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Disconnecting Guardian...',
                  ),
                ],
              ),
            );
          }

          if (state is GuardianFailure) {
            return _GuardianError(
              message: state.message,
            );
          }

          if (state is GuardianConnectionCodeLoading) {
            return const _NotConnectedView();
          }

          if (state is GuardianConnectionCodeGenerated) {
            return _ConnectionCodeView(
              code: state.code,
              platform: state.platform,
            );
          }

          if (state is GuardianLoaded) {
            return _GuardianContent(
              account: state.account,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _GuardianContent extends StatelessWidget {
  final GuardianAccount account;

  const _GuardianContent({
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    if (!account.isConnected) {
      return const _NotConnectedView();
    }

    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () async {
        context.read<GuardianBloc>().add(
              GuardianLoadRequested(),
            );
      },
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _StatusCard(
            account: account,
          ),

          const SizedBox(height: 24),

          const Text(
            'Account Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _MetricCard(
            title: 'Balance',
            value: account.balance.toStringAsFixed(2),
            icon: Icons.account_balance_wallet_outlined,
          ),

          const SizedBox(height: 12),

          _MetricCard(
            title: 'Equity',
            value: account.equity.toStringAsFixed(2),
            icon: Icons.show_chart,
          ),

          const SizedBox(height: 12),

          _MetricCard(
            title: 'Current Drawdown',
            value:
                '${account.currentDrawdown.toStringAsFixed(2)}%',
            icon: Icons.trending_down,
          ),

          const SizedBox(height: 12),

          _MetricCard(
            title: 'Open Positions',
            value: account.openPositions.toString(),
            icon: Icons.swap_vert,
          ),

          const SizedBox(height: 12),

          _MetricCard(
            title: 'Daily P/L',
            value:
                account.dailyProfitLoss.toStringAsFixed(2),
            icon: Icons.payments_outlined,
          ),

          const SizedBox(height: 28),

          const Divider(),

          const SizedBox(height: 16),

          OutlinedButton.icon(
            onPressed: () {
              _showDisconnectConfirmation(
                context,
                account,
              );
            },
            icon: const Icon(
              Icons.link_off,
            ),
            label: const Text(
              'Disconnect Trading Account',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
              side: BorderSide(
                color: theme.colorScheme.error,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 14,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Disconnecting will stop Guardian protection for this trading account.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(
                alpha: 0.60,
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _showDisconnectConfirmation(
    BuildContext context,
    GuardianAccount account,
  ) async {
    final shouldDisconnect =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Disconnect Guardian?',
          ),
          content: Text(
            'Are you sure you want to disconnect '
            '${account.platform} account '
            '${account.accountNumber ?? ''}?\n\n'
            'Guardian protection will stop for '
            'this trading account.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(
                  false,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(
                  true,
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor:
                    Theme.of(dialogContext)
                        .colorScheme
                        .error,
              ),
              child: const Text(
                'Disconnect',
              ),
            ),
          ],
        );
      },
    );

    if (shouldDisconnect != true) {
      return;
    }

    if (!context.mounted) {
      return;
    }

    context.read<GuardianBloc>().add(
          GuardianDisconnectRequested(),
        );
  }
}

class _NotConnectedView extends StatelessWidget {
  const _NotConnectedView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 30),

          Center(
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(
                  alpha: 0.08,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shield_outlined,
                size: 44,
                color: theme.colorScheme.primary,
              ),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Guardian Not Connected',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Connect an MT4 or MT5 trading account to monitor your account and enable Guardian protection.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(
                alpha: 0.65,
              ),
            ),
          ),

          const SizedBox(height: 28),

          BlocBuilder<GuardianBloc, GuardianState>(
            builder: (context, state) {
              final isGenerating =
                  state is GuardianConnectionCodeLoading;

              return ElevatedButton.icon(
                onPressed: isGenerating
                    ? null
                    : () {
                        _showPlatformSelector(
                          context,
                        );
                      },
                icon: isGenerating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.add_link,
                      ),
                label: Text(
                  isGenerating
                      ? 'Generating Code...'
                      : 'Connect Trading Account',
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          Text(
            'Choose MT4 or MT5 to generate a temporary Guardian connection code.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  void _showPlatformSelector(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose Trading Platform',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                ListTile(
                  leading: const Icon(
                    Icons.desktop_windows_outlined,
                  ),
                  title: const Text(
                    'MetaTrader 4',
                  ),
                  subtitle: const Text(
                    'MT4 Guardian',
                  ),
                  onTap: () {
                    Navigator.pop(
                      sheetContext,
                    );

                    context.read<GuardianBloc>().add(
                          GuardianConnectionCodeRequested(
                            platform: 'MT4',
                          ),
                        );
                  },
                ),

                const Divider(),

                ListTile(
                  leading: const Icon(
                    Icons.desktop_windows_outlined,
                  ),
                  title: const Text(
                    'MetaTrader 5',
                  ),
                  subtitle: const Text(
                    'MT5 Guardian',
                  ),
                  onTap: () {
                    Navigator.pop(
                      sheetContext,
                    );

                    context.read<GuardianBloc>().add(
                          GuardianConnectionCodeRequested(
                            platform: 'MT5',
                          ),
                        );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ConnectionCodeView extends StatelessWidget {
  final String code;
  final String platform;

  const _ConnectionCodeView({
    required this.code,
    required this.platform,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(
                alpha: 0.08,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.link,
              size: 44,
              color: theme.colorScheme.primary,
            ),
          ),

          const SizedBox(height: 24),

          Text(
            '$platform Connection Code',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Enter this code into your Tradewisser $platform Guardian EA.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(
                alpha: 0.65,
              ),
            ),
          ),

          const SizedBox(height: 28),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 24,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(
                  alpha: 0.30,
                ),
              ),
            ),
            child: Column(
              children: [
                Text(
                  code,
                  textAlign: TextAlign.center,
                  style:
                      theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Valid for 15 minutes',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                context.read<GuardianBloc>().add(
                      GuardianLoadRequested(),
                    );
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
              label: const Text(
                'Back to Guardian',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final GuardianAccount account;

  const _StatusCard({
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
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
            children: [
              const Icon(
                Icons.shield_outlined,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  'Guardian Status',
                  style:
                      theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Text(
                account.isEnabled
                    ? 'Protected'
                    : 'Disabled',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: account.isEnabled
                      ? Colors.green
                      : theme.colorScheme.error,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            '${account.platform} • '
            '${account.accountNumber ?? 'Unknown Account'}',
          ),

          if (account.broker != null) ...[
            const SizedBox(height: 6),
            Text(
              account.broker!,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(
            alpha: 0.18,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: theme.colorScheme.primary,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyMedium,
            ),
          ),

          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _GuardianError extends StatelessWidget {
  final String message;

  const _GuardianError({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
            ),

            const SizedBox(height: 16),

            Text(
              message,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                context.read<GuardianBloc>().add(
                      GuardianLoadRequested(),
                    );
              },
              child: const Text(
                'Try Again',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
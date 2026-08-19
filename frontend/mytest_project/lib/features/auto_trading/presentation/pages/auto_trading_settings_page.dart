import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mytest_project/features/auto_trading/presentation/bloc/auto_trading_bloc.dart';
import 'package:mytest_project/features/auto_trading/domain/entities/auto_trading_settings.dart';

class AutoTradingSettingsPage extends StatelessWidget {
  const AutoTradingSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: context.read<AutoTradingBloc>()
        ..add(const AutoTradingLoadRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Auto Trading'),
        ),
        body: BlocConsumer<AutoTradingBloc, AutoTradingState>(
          listener: (context, state) {
            if (state is AutoTradingFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AutoTradingLoading ||
                state is AutoTradingInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            AutoTradingSettings settings;

            if (state is AutoTradingLoaded) {
              settings = state.settings;
            } else if (state is AutoTradingUpdating) {
              settings = state.settings;
            } else if (state is AutoTradingFailure &&
                state.previousSettings != null) {
              settings = state.previousSettings!;
            } else {
              return const Center(
                child: Text(
                  'Unable to load Auto Trading settings.',
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // ==========================================================
                // HEADER
                // ==========================================================

                _buildHeader(
                  context,
                  theme,
                  settings,
                ),

                const SizedBox(height: 28),

                // ==========================================================
                // MASTER SWITCH
                // ==========================================================

                Text(
                  'Auto Trading',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                _SettingTile(
                  icon: Icons.smart_toy_outlined,
                  title: 'Auto Trading',
                  subtitle: settings.enabled
                      ? 'Auto Trading is currently enabled'
                      : 'Automatically execute eligible signals',
                  trailing: Switch(
                    value: settings.enabled,
                    onChanged: state is AutoTradingUpdating
                        ? null
                        : (enabled) {
                            context
                                .read<AutoTradingBloc>()
                                .add(
                                  AutoTradingChanged(enabled),
                                );
                          },
                  ),
                ),

                const SizedBox(height: 28),

                // ==========================================================
                // SIGNAL FILTERS
                // ==========================================================

                Text(
                  'Signal Filters',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                _PercentageTile(
                  icon: Icons.analytics_outlined,
                  title: 'Minimum Signal Quality',
                  subtitle:
                      'Only execute signals meeting this quality level',
                  value: settings.minimumSignalQuality,
                  enabled: state is! AutoTradingUpdating,
                  onChanged: (value) {
                    context.read<AutoTradingBloc>().add(
                          AutoTradingPreferencesChanged(
                            minimumSignalQuality: value,
                          ),
                        );
                  },
                ),

                const SizedBox(height: 10),

                _PercentageTile(
                  icon: Icons.psychology_outlined,
                  title: 'Minimum AI Confidence',
                  subtitle:
                      'Only execute signals meeting this AI confidence',
                  value: settings.minimumAiConfidence,
                  enabled: state is! AutoTradingUpdating,
                  onChanged: (value) {
                    context.read<AutoTradingBloc>().add(
                          AutoTradingPreferencesChanged(
                            minimumAiConfidence: value,
                          ),
                        );
                  },
                ),

                const SizedBox(height: 28),

                // ==========================================================
                // TRADE DIRECTION
                // ==========================================================

                Text(
                  'Trade Direction',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                _SwitchTile(
                  icon: Icons.trending_up_rounded,
                  title: 'Allow BUY',
                  subtitle:
                      'Allow Auto Trading to execute BUY signals',
                  value: settings.allowBuy,
                  enabled: state is! AutoTradingUpdating,
                  onChanged: (value) {
                    context.read<AutoTradingBloc>().add(
                          AutoTradingPreferencesChanged(
                            allowBuy: value,
                          ),
                        );
                  },
                ),

                const SizedBox(height: 10),

                _SwitchTile(
                  icon: Icons.trending_down_rounded,
                  title: 'Allow SELL',
                  subtitle:
                      'Allow Auto Trading to execute SELL signals',
                  value: settings.allowSell,
                  enabled: state is! AutoTradingUpdating,
                  onChanged: (value) {
                    context.read<AutoTradingBloc>().add(
                          AutoTradingPreferencesChanged(
                            allowSell: value,
                          ),
                        );
                  },
                ),

                const SizedBox(height: 28),

                // ==========================================================
                // SAFETY REQUIREMENTS
                // ==========================================================

                Text(
                  'Safety Requirements',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                _SwitchTile(
                  icon: Icons.psychology_outlined,
                  title: 'Require AI Confirmation',
                  subtitle:
                      'Only execute signals that meet AI confirmation rules',
                  value: settings.requireAiConfirmation,
                  enabled: state is! AutoTradingUpdating,
                  onChanged: (value) {
                    context.read<AutoTradingBloc>().add(
                          AutoTradingPreferencesChanged(
                            requireAiConfirmation: value,
                          ),
                        );
                  },
                ),

                const SizedBox(height: 10),

                _SwitchTile(
                  icon: Icons.shield_outlined,
                  title: 'Require Stop Loss',
                  subtitle:
                      'Every automatic trade must have a stop loss',
                  value: settings.requireStopLoss,
                  enabled: state is! AutoTradingUpdating,
                  onChanged: (value) {
                    context.read<AutoTradingBloc>().add(
                          AutoTradingPreferencesChanged(
                            requireStopLoss: value,
                          ),
                        );
                  },
                ),

                const SizedBox(height: 10),

                _SwitchTile(
                  icon: Icons.flag_outlined,
                  title: 'Require Take Profit',
                  subtitle:
                      'Every automatic trade must have a take profit',
                  value: settings.requireTakeProfit,
                  enabled: state is! AutoTradingUpdating,
                  onChanged: (value) {
                    context.read<AutoTradingBloc>().add(
                          AutoTradingPreferencesChanged(
                            requireTakeProfit: value,
                          ),
                        );
                  },
                ),

                const SizedBox(height: 28),

                // ==========================================================
                // TRADING PLATFORM
                // ==========================================================

                Text(
                  'Trading Platform',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                const _SettingTile(
                  icon: Icons.desktop_windows_rounded,
                  title: 'MT4 Guardian',
                  subtitle:
                      'Connect your MetaTrader 4 account',
                  trailing: _StatusBadge(
                    text: 'Not Connected',
                    color: Colors.orange,
                  ),
                ),

                const SizedBox(height: 10),

                const _SettingTile(
                  icon: Icons.desktop_windows_rounded,
                  title: 'MT5 Guardian',
                  subtitle:
                      'Connect your MetaTrader 5 account',
                  trailing: _StatusBadge(
                    text: 'Not Connected',
                    color: Colors.orange,
                  ),
                ),

                const SizedBox(height: 28),

                // ==========================================================
                // RISK PROTECTION
                // ==========================================================

                Text(
                  'Risk Protection',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                const _SettingTile(
                  icon: Icons.percent_rounded,
                  title: 'Risk Per Trade',
                  subtitle:
                      'Maximum risk allowed for each trade',
                  trailing: Text(
                    '1%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const _SettingTile(
                  icon: Icons.warning_amber_rounded,
                  title: 'Daily Loss Limit',
                  subtitle:
                      'Stop automatic trading after this loss',
                  trailing: Text(
                    '2%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const _SettingTile(
                  icon: Icons.trending_down_rounded,
                  title: 'Maximum Drawdown',
                  subtitle:
                      'Maximum account drawdown allowed',
                  trailing: Text(
                    '5%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ==========================================================
                // WARNING
                // ==========================================================

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          Colors.orange.withValues(alpha: 0.20),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Auto Trading can place trades automatically. '
                          'Make sure your Guardian account and risk settings '
                          'are configured correctly before enabling it.',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ThemeData theme,
    AutoTradingSettings settings,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color:
                  theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.bolt_rounded,
              color: theme.colorScheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Auto Trading',
                  style:
                      theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  settings.enabled
                      ? 'Auto Trading is enabled.'
                      : 'Automatically execute eligible '
                          'Tradewisser signals.',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SETTING TILE
// ============================================================================

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
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
          color:
              theme.colorScheme.outline.withValues(alpha: 0.15),
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
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style:
                      theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface
                        .withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          trailing,
        ],
      ),
    );
  }
}

// ============================================================================
// SWITCH TILE
// ============================================================================

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: Switch(
        value: value,
        onChanged: enabled ? onChanged : null,
      ),
    );
  }
}

// ============================================================================
// PERCENTAGE TILE
// ============================================================================

class _PercentageTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final double value;
  final bool enabled;
  final ValueChanged<double> onChanged;

  const _PercentageTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: SizedBox(
        width: 120,
        child: Slider(
          value: value.clamp(0.0, 100.0),
          min: 0,
          max: 100,
          divisions: 20,
          label: '${value.toStringAsFixed(0)}%',
          onChanged: enabled ? onChanged : null,
        ),
      ),
    );
  }
}

// ============================================================================
// STATUS BADGE
// ============================================================================

class _StatusBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _StatusBadge({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/guardian_bloc.dart';

class GuardianPage extends StatefulWidget {
  final String platform;

  const GuardianPage({
    super.key,
    required this.platform,
  });

  @override
  State<GuardianPage> createState() => _GuardianPageState();
}
class _GuardianPageState extends State<GuardianPage> {
  @override
  void initState() {
    super.initState();

    context.read<GuardianBloc>().add(
  GuardianLoadRequested(
    platform: widget.platform,
  ),
  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.platform} Guardian',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<GuardianBloc, GuardianState>(
        listener: (context, state) {
          if (state is GuardianConnectionCodeGenerated) {
            _showConnectionCode(
              context,
              state.code,
            );
          }

          if (state is GuardianDisconnected) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Guardian disconnected successfully.',
                ),
              ),
            );
          }

          if (state is GuardianFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GuardianLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is GuardianFailure) {
            return _ErrorView(
              message: state.message,
              onRetry: () {
                context.read<GuardianBloc>().add(
                  GuardianLoadRequested(
                    platform: widget.platform,
                  ),
                );
              },
            );
          }

          if (state is GuardianLoaded) {
            final account = state.account;

            return RefreshIndicator(
              onRefresh: () async {
               context.read<GuardianBloc>().add(
                  GuardianLoadRequested(
                    platform: widget.platform,
                  ),
                );
              },
              child: ListView(
                physics:
                    const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                children: [
                  _StatusCard(
                    platform: widget.platform,
                    connected: account.isConnected,
                  ),

                  const SizedBox(height: 20),

                  if (account.isConnected)
                    _ConnectedAccountCard(
                      accountNumber:
                          account.accountNumber,
                      broker: account.broker,
                      balance: account.balance,
                      equity: account.equity,
                      drawdown:
                          account.currentDrawdown,
                      openPositions:
                          account.openPositions,
                      dailyProfitLoss:
                          account.dailyProfitLoss,
                    )
                  else
                    _NotConnectedCard(
                      platform: widget.platform,
                      onConnect: () {
                        context
                            .read<GuardianBloc>()
                            .add(
                            GuardianConnectionCodeRequested(
                                platform: widget.platform,
                              ),
                            );
                      },
                    ),

                  if (account.isConnected) ...[
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed:
                            state is GuardianDisconnecting
                                ? null
                                : () {
                                    _confirmDisconnect(
                                      context,
                                    );
                                  },
                        icon: const Icon(
                          Icons.link_off,
                        ),
                        label: state
                                is GuardianDisconnecting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Disconnect Guardian',
                              ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }

          if (state
              is GuardianConnectionCodeLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state
              is GuardianConnectionCodeGenerated) {
            return _ConnectionCodeView(
              platform: state.platform,
              code: state.code,
              onDone: () {
               context.read<GuardianBloc>().add(
                  GuardianLoadRequested(
                    platform: widget.platform,
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  void _showConnectionCode(
    BuildContext context,
    String code,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Connection Code',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter this code in your Tradewisser Guardian EA.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SelectableText(
                code,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(text: code),
                  );

                  if (!dialogContext.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(
                    dialogContext,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Connection code copied.',
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.copy,
                ),
                label: const Text(
                  'Copy Code',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);

               context.read<GuardianBloc>().add(
                  GuardianLoadRequested(
                    platform: widget.platform,
                  ),
                );
               },
              child: const Text(
                'Done',
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmDisconnect(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Disconnect Guardian?',
          ),
          content: Text(
            'This will disconnect your ${widget.platform} '
            'Guardian account from Tradewisser.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel',
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                context.read<GuardianBloc>().add(
                  GuardianDisconnectRequested(
                    platform: widget.platform,
                  ),
                );
              },
              child: const Text(
                'Disconnect',
              ),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================================
// STATUS CARD
// ============================================================================

class _StatusCard extends StatelessWidget {
  final String platform;
  final bool connected;

  const _StatusCard({
    required this.platform,
    required this.connected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: connected
              ? [
                  Colors.green.shade700,
                  Colors.green.shade900,
                ]
              : [
                  Colors.orange.shade700,
                  Colors.deepOrange.shade900,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Icon(
            connected
                ? Icons.shield
                : Icons.shield_outlined,
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(height: 14),
          Text(
            '$platform Guardian',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            connected
                ? 'Connected and monitoring'
                : 'Not Connected',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// NOT CONNECTED
// ============================================================================

class _NotConnectedCard extends StatelessWidget {
  final String platform;
  final VoidCallback onConnect;

  const _NotConnectedCard({
    required this.platform,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(
              Icons.link_off,
              size: 50,
            ),
            const SizedBox(height: 16),
            const Text(
              'Guardian is not connected',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Connect your $platform trading account '
              'using the Tradewisser Guardian EA.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onConnect,
                icon: const Icon(
                  Icons.link,
                ),
                label: Text(
                  'Connect $platform',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// CONNECTION CODE
// ============================================================================

class _ConnectionCodeView extends StatelessWidget {
  final String platform;
  final String code;
  final VoidCallback onDone;

  const _ConnectionCodeView({
    required this.platform,
    required this.code,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.vpn_key,
              size: 70,
            ),
            const SizedBox(height: 20),
            Text(
              '$platform Connection Code',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Enter this code in your Guardian EA.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            SelectableText(
              code,
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                letterSpacing: 5,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(text: code),
                );

                if (!context.mounted) return;

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Connection code copied.',
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.copy,
              ),
              label: const Text(
                'Copy Code',
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onDone,
              child: const Text(
                'Done',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// CONNECTED ACCOUNT
// ============================================================================

class _ConnectedAccountCard
    extends StatelessWidget {
  final String? accountNumber;
  final String? broker;
  final double balance;
  final double equity;
  final double drawdown;
  final int openPositions;
  final double dailyProfitLoss;

  const _ConnectedAccountCard({
    required this.accountNumber,
    required this.broker,
    required this.balance,
    required this.equity,
    required this.drawdown,
    required this.openPositions,
    required this.dailyProfitLoss,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Account Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 18),

            _InfoRow(
              label: 'Account',
              value:
                  accountNumber ?? 'Unknown',
            ),

            _InfoRow(
              label: 'Broker',
              value: broker ?? 'Unknown',
            ),

            _InfoRow(
              label: 'Balance',
              value:
                  balance.toStringAsFixed(2),
            ),

            _InfoRow(
              label: 'Equity',
              value:
                  equity.toStringAsFixed(2),
            ),

            _InfoRow(
              label: 'Drawdown',
              value:
                  '${drawdown.toStringAsFixed(2)}%',
            ),

            _InfoRow(
              label: 'Open Positions',
              value:
                  openPositions.toString(),
            ),

            _InfoRow(
              label: 'Daily P/L',
              value:
                  dailyProfitLoss
                      .toStringAsFixed(2),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// INFO ROW
// ============================================================================

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// ERROR
// ============================================================================

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
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
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onRetry,
              child: const Text(
                'Retry',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/trading_signal_bloc.dart';
import '../widgets/signal_card.dart';
import 'signal_details_page.dart';

class SignalsPage extends StatefulWidget {
  const SignalsPage({super.key});

  @override
  State<SignalsPage> createState() => _SignalsPageState();
}

class _SignalsPageState extends State<SignalsPage> {
  @override
  void initState() {
    super.initState();

    _loadSignals();
  }

  void _loadSignals() {
    context.read<TradingSignalBloc>().add(
      LoadTradingSignals(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trading Signals',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<TradingSignalBloc, TradingSignalState>(
        builder: (context, state) {
          if (state is TradingSignalLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is TradingSignalFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadSignals,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is TradingSignalLoaded) {
            if (state.signals.isEmpty) {
              return const Center(
                child: Text(
                  'No trading signals available.',
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _loadSignals();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.signals.length,
                itemBuilder: (context, index) {
                  final signal = state.signals[index];

                  return SignalCard(
                    signal: signal,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SignalDetailsPage(
                            signal: signal,
                          ),
                        ),
                      );

                      // Reload signals when returning
                      // from Signal Details.
                      if (mounted) {
                        _loadSignals();
                      }
                    },
                  );
                },
              ),
            );
          }

          // If the BLoC is in a details or AI state,
          // reload the signals instead of showing a blank page.
          if (state is TradingSignalDetailsLoaded ||
              state is AiSignalConfirmationLoading ||
              state is AiSignalConfirmationLoaded ||
              state is AiSignalConfirmationFailure) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _loadSignals();
              }
            });

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
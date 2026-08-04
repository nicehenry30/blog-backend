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

    context.read<TradingSignalBloc>().add(LoadTradingSignals());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trading Signals',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: BlocBuilder<TradingSignalBloc, TradingSignalState>(
        builder: (context, state) {
          if (state is TradingSignalLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TradingSignalFailure) {
            return Center(child: Text(state.message));
          }

          if (state is TradingSignalLoaded) {
            if (state.signals.isEmpty) {
              return const Center(child: Text('No trading signals available.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.signals.length,
              itemBuilder: (context, index) {
                final signal = state.signals[index];

                return SignalCard(
                  signal: signal,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SignalDetailsPage(signal: signal),
                      ),
                    );
                  },
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

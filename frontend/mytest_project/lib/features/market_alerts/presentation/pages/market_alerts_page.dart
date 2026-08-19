import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mytest_project/core/di/injection_container.dart';
import 'package:mytest_project/features/market_alerts/presentation/bloc/market_alert_bloc.dart';
import 'package:mytest_project/features/market_alerts/presentation/bloc/market_alert_event.dart';
import 'package:mytest_project/features/market_alerts/presentation/bloc/market_alert_state.dart';
import 'package:mytest_project/features/market_alerts/presentation/widgets/market_alert_card.dart';

class MarketAlertsPage extends StatelessWidget {
  const MarketAlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<MarketAlertBloc>()
        ..add(LoadMarketAlerts()),
      child: const _MarketAlertsView(),
    );
  }
}

class _MarketAlertsView extends StatelessWidget {
  const _MarketAlertsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Alerts'),
        centerTitle: true,
      ),
      body: BlocBuilder<MarketAlertBloc, MarketAlertState>(
        builder: (context, state) {
          if (state is MarketAlertLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is MarketAlertFailure) {
            return _ErrorView(
              message: state.message,
              onRetry: () {
                context
                    .read<MarketAlertBloc>()
                    .add(LoadMarketAlerts());
              },
            );
          }

          if (state is MarketAlertLoaded) {
            if (state.alerts.isEmpty) {
              return const _EmptyView();
            }

            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<MarketAlertBloc>()
                    .add(LoadMarketAlerts());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.alerts.length,
                itemBuilder: (context, index) {
                  return MarketAlertCard(
                    alert: state.alerts[index],
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 56,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load market alerts',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 60,
            ),
            SizedBox(height: 16),
            Text(
              'No market alerts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'There are no active market alerts at the moment.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'payment_webview_page.dart';

import '../../../../core/di/injection_container.dart';
import '../bloc/subscription_bloc.dart';
import '../widgets/current_subscription_card.dart';
import '../widgets/plan_card.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<SubscriptionBloc>()
            ..add(LoadSubscription()),
      child: const _SubscriptionView(),
    );
  }
}

class _SubscriptionView extends StatelessWidget {
  const _SubscriptionView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription'),
        centerTitle: true,
      ),
      body: BlocConsumer<SubscriptionBloc, SubscriptionState>(
        listener: (context, state) async {
  if (state is SubscriptionPaymentReady) {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<SubscriptionBloc>(),
          child: PaymentWebViewPage(
            paymentUrl: state.authorizationUrl,
          ),
        ),
      ),
    );

    if (context.mounted) {
      context
          .read<SubscriptionBloc>()
          .add(
            LoadSubscription(),
          );
    }
  }
},

        builder: (context, state) {
          if (state is SubscriptionLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is SubscriptionFailure) {
            return _SubscriptionErrorView(
              message: state.message,
              onBack: () {
                context
                    .read<SubscriptionBloc>()
                    .add(
                      LoadSubscription(),
                    );
              },
            );
          }

          if (state is SubscriptionLoaded) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                CurrentSubscriptionCard(
                  subscription:
                      state.currentSubscription,
                ),

                const SizedBox(height: 24),

                const Text(
                  'Available Plans',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                ...state.plans.map(
                  (plan) {
                    final isCurrentPlan =
                        state.currentSubscription
                                ?.plan
                                .id ==
                            plan.id;

                    return PlanCard(
                      plan: plan,
                      isCurrentPlan:
                          isCurrentPlan,
                      onPressed: () {
                        context
                            .read<SubscriptionBloc>()
                            .add(
                              InitializeSubscriptionPayment(
                                plan.id,
                              ),
                            );
                      },
                    );
                  },
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _SubscriptionErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onBack;

  const _SubscriptionErrorView({
    required this.message,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.withValues(
                  alpha: 0.1,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Upgrade Unavailable',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: onBack,
                icon: const Icon(
                  Icons.arrow_back,
                ),
                label: const Text(
                  'Back to Plans',
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
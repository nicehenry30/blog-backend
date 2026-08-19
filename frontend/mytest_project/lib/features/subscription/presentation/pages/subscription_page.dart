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
        final verified =
            await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value:
                  context.read<SubscriptionBloc>(),
              child: PaymentWebViewPage(
                paymentUrl:
                    state.authorizationUrl,
              ),
            ),
          ),
        );

        if (verified == true &&
            context.mounted) {
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
            return Center(
              child: Text(state.message),
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
                    fontWeight:
                        FontWeight.bold,
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
                            .read<
                                SubscriptionBloc>()
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
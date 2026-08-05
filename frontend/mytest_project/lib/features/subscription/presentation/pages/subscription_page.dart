import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/di/injection_container.dart';
import '../bloc/subscription_bloc.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<SubscriptionBloc>()..add(LoadSubscription()),
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
      ),
      body: BlocConsumer<SubscriptionBloc, SubscriptionState>(
       listener: (context, state) {
  if (state is SubscriptionPaymentReady) {
    final uri = Uri.parse(state.authorizationUrl);

    launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    ).then((opened) {
      if (!opened && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not open payment page.',
            ),
          ),
        );
      }
    });
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
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current Subscription',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          state.currentSubscription == null
                              ? 'FREE PLAN'
                              : state.currentSubscription!.plan.name,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),

                        if (state.currentSubscription != null)
                          Text(
                            'Status: ${state.currentSubscription!.status}',
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Available Plans',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),

                const SizedBox(height: 12),

                ...state.plans.map(
                  (plan) => Card(
                    margin:
                        const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding:
                          const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            plan.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(plan.description),

                          const SizedBox(height: 12),

                          Text(
                            '${plan.currency} ${plan.price}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                context
                                    .read<SubscriptionBloc>()
                                    .add(
                                      InitializeSubscriptionPayment(
                                        plan.id,
                                      ),
                                    );
                              },
                              child: const Text(
                                'Upgrade',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
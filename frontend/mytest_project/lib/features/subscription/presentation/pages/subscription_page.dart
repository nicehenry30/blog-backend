import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'payment_webview_page.dart';
import 'crypto_payment_page.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/plan.dart';
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
  final subscriptionBloc =
      context.read<SubscriptionBloc>();

  await Navigator.push<bool>(
    context,
    MaterialPageRoute(
      builder: (_) => BlocProvider.value(
        value: subscriptionBloc,
        child: PaymentWebViewPage(
          paymentUrl:
              state.payment.authorizationUrl,
        ),
      ),
    ),
  );

  if (!context.mounted) {
    return;
  }

  subscriptionBloc.add(
    LoadSubscription(),
  );
}

if (state is SubscriptionCryptoPaymentReady) {
      final subscriptionBloc =
          context.read<SubscriptionBloc>();

      await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: subscriptionBloc,
            child: CryptoPaymentPage(
              payment: state.payment,
            ),
          ),
        ),
      );

      if (!context.mounted) {
        return;
      }

      subscriptionBloc.add(
        LoadSubscription(),
      );
    }

          if (state
              is SubscriptionCryptoPaymentSubmitted) {
            if (!context.mounted) {
              return;
            }

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  behavior: SnackBarBehavior.floating,
                ),
              );

            context.read<SubscriptionBloc>().add(
                  LoadSubscription(),
                );
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
                context.read<SubscriptionBloc>().add(
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
                        _showPaymentMethodSheet(
                          context,
                          plan,
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

  Future<void> _showPaymentMethodSheet(
    BuildContext context,
    Plan plan,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              8,
              20,
              24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose Payment Method',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  plan.name,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 20),

                _PaymentMethodTile(
                  icon: Icons.credit_card,
                  title: 'Paystack',
                  subtitle:
                      'Pay securely with Paystack',
                  onTap: () {
                    Navigator.pop(sheetContext);

                    context
                        .read<SubscriptionBloc>()
                        .add(
                          InitializeSubscriptionPayment(
                            plan.id,
                          ),
                        );
                  },
                ),

                const SizedBox(height: 12),

                _PaymentMethodTile(
                  icon: Icons.currency_bitcoin,
                  title: 'USDT (TRC20)',
                  subtitle:
                      'Pay with Tether using the TRON network',
                  onTap: () {
                    Navigator.pop(sheetContext);

                    context
                        .read<SubscriptionBloc>()
                        .add(
                          InitializeCryptoSubscriptionPayment(
                            plan.id,
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

class _PaymentMethodTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PaymentMethodTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            borderRadius:
                BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: Colors.blue,
                ),
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
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      style: TextStyle(
                        color:
                            Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
            ],
          ),
        ),
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
          mainAxisAlignment:
              MainAxisAlignment.center,
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
                  shape:
                      RoundedRectangleBorder(
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'payment_details_page.dart';

import '../../../../core/di/injection_container.dart';

import '../bloc/payment_bloc.dart';
import '../widgets/payment_card.dart';

class PaymentHistoryPage extends StatelessWidget {
  const PaymentHistoryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<PaymentBloc>()
            ..add(
              LoadPayments(),
            ),
      child: const _PaymentHistoryView(),
    );
  }
}

class _PaymentHistoryView
    extends StatelessWidget {
  const _PaymentHistoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment History',
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<
          PaymentBloc,
          PaymentState>(
        builder: (context, state) {
          if (state is PaymentLoading) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (state is PaymentFailure) {
            return Center(
              child: Text(
                state.message,
              ),
            );
          }

          if (state is PaymentsLoaded) {
            if (state.payments.isEmpty) {
              return const Center(
                child: Text(
                  'No payment history found.',
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<PaymentBloc>()
                    .add(
                      LoadPayments(),
                    );
              },
              child: ListView.builder(
                padding:
                    const EdgeInsets.all(
                  16,
                ),
                itemCount:
                    state.payments.length,
                itemBuilder:
                    (context, index) {
                  final payment =
                      state.payments[index];
                 return PaymentCard(
                  payment: payment,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PaymentDetailsPage(
                          payment: payment,
                        ),
                      ),
                    );
                  },
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
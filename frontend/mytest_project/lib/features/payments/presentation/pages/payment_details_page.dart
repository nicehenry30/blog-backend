import 'package:flutter/material.dart';

import '../../domain/entities/payment.dart';

class PaymentDetailsPage extends StatelessWidget {
  final Payment payment;

  const PaymentDetailsPage({
    super.key,
    required this.payment,
  });

  Widget buildRow(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Details',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
          ),
          child: Padding(
            padding:
                const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Center(
                  child: Icon(
                    Icons.payment,
                    size: 70,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 20),

                buildRow(
                  'Plan',
                  payment.planName ??
                      'Subscription',
                ),

                buildRow(
                  'Amount',
                  payment.formattedAmount,
                ),

                buildRow(
                  'Status',
                  payment.status,
                ),

                buildRow(
                  'Reference',
                  payment.reference,
                ),

                buildRow(
                  'Transaction ID',
                  payment.transactionId ??
                      '-',
                ),

                buildRow(
                  'Gateway',
                  payment.gateway ??
                      'Paystack',
                ),

                buildRow(
                  'Paid At',
                  payment.paidAt
                          ?.toString() ??
                      '-',
                ),

                buildRow(
                  'Created',
                  payment.createdAt
                      .toString(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
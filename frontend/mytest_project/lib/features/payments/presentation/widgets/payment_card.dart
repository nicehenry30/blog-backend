import 'package:flutter/material.dart';

import '../../domain/entities/payment.dart';

class PaymentCard extends StatelessWidget {
  final Payment payment;

  final VoidCallback onTap;

  const PaymentCard({
    super.key,
    required this.payment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _statusColor();

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.payment,
                    color: color,
                    size: 30,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      payment.planName ??
                          'Subscription',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(
                        alpha: 0.15,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),
                    child: Text(
                      payment.status
                          .toUpperCase(),
                      style: TextStyle(
                        color: color,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Text(
                payment.formattedAmount,
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                payment.reference,
                style: TextStyle(
                  color:
                      Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 18,
                  ),

                  const SizedBox(width: 8),

                  Text(
                    payment.createdAt
                        .toString()
                        .split(' ')
                        .first,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor() {
    switch (payment.status) {
      case 'successful':
        return Colors.green;

      case 'pending':
        return Colors.orange;

      case 'failed':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }
}
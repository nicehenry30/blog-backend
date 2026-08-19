import 'package:flutter/material.dart';

import '../../domain/entities/subscription.dart';

class CurrentSubscriptionCard extends StatelessWidget {
  final Subscription? subscription;

  const CurrentSubscriptionCard({
    super.key,
    required this.subscription,
  });

  @override
  Widget build(BuildContext context) {
    final isFree = subscription == null;

    final Color color =
        isFree ? Colors.green : Colors.blue;

    final IconData icon =
        isFree
            ? Icons.eco
            : Icons.workspace_premium;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Subscription',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor:
                      color.withValues(alpha: .15),
                  child: Icon(
                    icon,
                    color: color,
                    size: 30,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        isFree
                            ? 'FREE PLAN'
                            : subscription!.plan.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        isFree
                            ? 'Always Active'
                            : 'Status: ${subscription!.status}',
                      ),
                    ],
                  ),
                ),

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'ACTIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            if (!isFree &&
                subscription!.expiresAt != null) ...[
              const SizedBox(height: 24),

              const Divider(),

              const SizedBox(height: 16),

              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 18,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      'Expires: ${subscription!.expiresAt}',
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
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

    final Color color = _planColor();
    final IconData icon = _planIcon();

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        isFree
                            ? 'Always Active'
                            : 'Status: ${subscription!.status.toUpperCase()}',
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'ACTIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            if (!isFree) ...[
              const SizedBox(height: 24),

              const Divider(),

              const SizedBox(height: 16),

              if (subscription!.startsAt != null)
                _InfoRow(
                  icon: Icons.play_circle_outline,
                  label:
                      'Started: ${_formatDate(subscription!.startsAt!)}',
                ),

              if (subscription!.expiresAt != null) ...[
                const SizedBox(height: 12),

                _InfoRow(
                  icon: Icons.calendar_today,
                  label:
                      'Expires: ${_formatDate(subscription!.expiresAt!)}',
                ),
              ],

              const SizedBox(height: 12),

              _InfoRow(
                icon: subscription!.autoRenew
                    ? Icons.autorenew
                    : Icons.block,
                label: subscription!.autoRenew
                    ? 'Auto-renew enabled'
                    : 'Auto-renew disabled',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _planColor() {
    if (subscription == null) {
      return Colors.green;
    }

    if (subscription!.plan.isPremium) {
      return Colors.blue;
    }

    if (subscription!.plan.isPropFirm) {
      return Colors.orange;
    }

    return Colors.blue;
  }

  IconData _planIcon() {
    if (subscription == null) {
      return Icons.eco;
    }

    if (subscription!.plan.isPremium) {
      return Icons.workspace_premium;
    }

    if (subscription!.plan.isPropFirm) {
      return Icons.emoji_events;
    }

    return Icons.star;
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(label),
        ),
      ],
    );
  }
}
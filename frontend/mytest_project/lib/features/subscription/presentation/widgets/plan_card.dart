import 'package:flutter/material.dart';

import '../../domain/entities/plan.dart';

class PlanCard extends StatelessWidget {
  final Plan plan;
  final bool isCurrentPlan;
  final VoidCallback onPressed;

  const PlanCard({
    super.key,
    required this.plan,
    required this.isCurrentPlan,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final color = _planColor();

    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.only(bottom: 28),
          elevation: 6,
          color: color.withValues(alpha: 0.04),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: color,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: color.withValues(alpha: 0.15),
                      child: Icon(
                        _planIcon(),
                        color: color,
                        size: 28,
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Text(
                        plan.name,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    if (isCurrentPlan)
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
                          'CURRENT',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 20),

                Text(
                  plan.description ?? '',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.end,
                  children: [
                    Text(
                      plan.displayPrice,
                      style: TextStyle(
                        color: color,
                        fontSize: 34,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                const Divider(),

                const SizedBox(height: 12),

                ...plan.features.map(
                  (feature) => Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: color,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),
                  SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed:
                        isCurrentPlan || plan.isFree
                            ? null
                            : onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          Colors.grey.shade300,
                      disabledForegroundColor:
                          Colors.grey.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      isCurrentPlan
                          ? 'Current Plan'
                          : plan.isFree
                              ? 'Free Forever'
                              : _buttonText(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (plan.isPremium)
          Positioned(
            top: 8,
            right: 20,
            child: _Ribbon(
              title: 'MOST POPULAR',
              color: Colors.blue,
            ),
          ),

        if (plan.isPropFirm)
          Positioned(
            top: 8,
            right: 20,
            child: _Ribbon(
              title: 'BEST VALUE',
              color: Colors.orange,
            ),
          ),
      ],
    );
  }

  Color _planColor() {
    if (plan.isFree) {
      return Colors.green;
    }

    if (plan.isPremium) {
      return Colors.blue;
    }

    if (plan.isPropFirm) {
      return Colors.orange;
    }

    return Colors.grey;
  }

  IconData _planIcon() {
    if (plan.isFree) {
      return Icons.eco;
    }

    if (plan.isPremium) {
      return Icons.workspace_premium;
    }

    if (plan.isPropFirm) {
      return Icons.emoji_events;
    }

    return Icons.star;
  }

  String _buttonText() {
    if (plan.isFree) {
      return 'Free Forever';
    }

    if (plan.isPremium) {
      return 'Upgrade Now';
    }

    if (plan.isPropFirm) {
      return 'Become a Prop Trader';
    }

    return 'Select Plan';
  }
}

class _Ribbon extends StatelessWidget {
  final String title;
  final Color color;

  const _Ribbon({
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}
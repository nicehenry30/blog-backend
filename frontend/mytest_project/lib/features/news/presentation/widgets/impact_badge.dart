import 'package:flutter/material.dart';

class ImpactBadge extends StatelessWidget {
  final String impact;

  const ImpactBadge({
    super.key,
    required this.impact,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    IconData icon;

    switch (impact.toLowerCase()) {
      case 'high':
        backgroundColor = Colors.red;
        icon = Icons.warning_rounded;
        break;

      case 'medium':
        backgroundColor = Colors.orange;
        icon = Icons.info_rounded;
        break;

      default:
        backgroundColor = Colors.green;
        icon = Icons.check_circle_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: backgroundColor,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: backgroundColor,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            impact.toUpperCase(),
            style: TextStyle(
              color: backgroundColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
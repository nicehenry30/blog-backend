import 'package:flutter/material.dart';

class SignalStatusBadge extends StatelessWidget {
  final String status;

  const SignalStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (status.toUpperCase()) {
      case 'ACTIVE':
        color = Colors.green;
        break;

      case 'PENDING':
        color = Colors.orange;
        break;

      case 'TP HIT':
        color = Colors.blue;
        break;

      case 'SL HIT':
        color = Colors.red;
        break;

      case 'EXPIRED':
        color = Colors.grey;
        break;

      default:
        color = Colors.black54;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
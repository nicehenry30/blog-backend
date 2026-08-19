import 'package:flutter/material.dart';


class SignalVisibilityBadge extends StatelessWidget {
  final String visibility;

  const SignalVisibilityBadge({
    super.key,
    required this.visibility,
  });

  @override
  Widget build(BuildContext context) {
    Color background;
    Color foreground;
    String text;

    switch (visibility.toLowerCase()) {
      case 'premium':
        background = Colors.blue.shade100;
        foreground = Colors.blue.shade800;
        text = 'PREMIUM';
        break;

      case 'pro':
        background = Colors.purple.shade100;
        foreground = Colors.purple.shade800;
        text = 'PRO';
        break;

      default:
        background = Colors.green.shade100;
        foreground = Colors.green.shade800;
        text = 'FREE';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: foreground,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
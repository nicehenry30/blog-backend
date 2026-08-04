import 'package:flutter/material.dart';

class WelcomeHeader extends StatelessWidget {
  final String name;

  const WelcomeHeader({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.primary.withValues(
          alpha: 0.08,
        ),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(
            alpha: 0.15,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary.withValues(
                alpha: 0.12,
              ),
            ),
            child: Icon(
              Icons.person_outline,
              color: theme.colorScheme.primary,
              size: 28,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(
                      alpha: 0.65,
                    ),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Stay disciplined. Trade with confidence.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(
                      alpha: 0.65,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.insights_rounded,
            color: theme.colorScheme.primary,
            size: 30,
          ),
        ],
      ),
    );
  }
}
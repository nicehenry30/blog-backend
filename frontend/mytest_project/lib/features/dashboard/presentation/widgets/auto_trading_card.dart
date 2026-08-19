import 'package:flutter/material.dart';

class AutoTradingCard extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onTap;

  const AutoTradingCard({
    super.key,
    required this.enabled,
    required this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: enabled
              ? theme.colorScheme.primary.withValues(alpha: 0.35)
              : theme.colorScheme.outline.withValues(alpha: 0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              // ==========================================================
              // ICON
              // ==========================================================

              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.bolt_rounded,
                  color: theme.colorScheme.primary,
                  size: 25,
                ),
              ),

              const SizedBox(width: 14),

              // ==========================================================
              // TEXT
              // ==========================================================

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Auto Trading',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      enabled
                          ? 'Auto Trading is enabled'
                          : 'Automatically execute eligible signals',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.60,
                        ),
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      enabled ? 'ON' : 'OFF',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: enabled
                            ? Colors.green.shade600
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.55,
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              // ==========================================================
              // SWITCH
              // ==========================================================

              Switch(
                value: enabled,
                onChanged: onChanged,
              ),

              const SizedBox(width: 4),

              // ==========================================================
              // SETTINGS ARROW
              // ==========================================================

              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurface.withValues(
                  alpha: 0.40,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
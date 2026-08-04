import 'package:flutter/material.dart';

class ConfidenceIndicator extends StatelessWidget {
  final double confidence;

  const ConfidenceIndicator({
    super.key,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overall Confidence',
          style: Theme.of(context).textTheme.titleSmall,
        ),

        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: confidence / 100,
                minHeight: 8,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(width: 12),

            Text(
              '${confidence.toInt()}%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
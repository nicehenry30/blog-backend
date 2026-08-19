import 'package:flutter/material.dart';

import '../../domain/entities/signal_history.dart';

class SignalHistoryTimeline extends StatelessWidget {
  final List<SignalHistory> histories;

  const SignalHistoryTimeline({
    super.key,
    required this.histories,
  });

  @override
  Widget build(BuildContext context) {
    if (histories.isEmpty) {
      return const Text(
        'No signal history available.',
      );
    }

    return Column(
      children: histories.asMap().entries.map((entry) {
        final index = entry.key;
        final history = entry.value;

        final isLast = index == histories.length - 1;

        return _HistoryItem(
          history: history,
          isLast: isLast,
        );
      }).toList(),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final SignalHistory history;
  final bool isLast;

  const _HistoryItem({
    required this.history,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // Timeline
        SizedBox(
          width: 30,
          child: Column(
            children: [

              Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
              ),

              if (!isLast)
                Container(
                  width: 2,
                  height: 80,
                  color: Colors.grey,
                ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // History content
        Expanded(
          child: Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    _formatEvent(history.event),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    history.description,
                    style: const TextStyle(
                      height: 1.4,
                    ),
                  ),

                  if (history.oldStatus != null ||
                      history.newStatus != null) ...[
                    const SizedBox(height: 8),

                    Text(
                      '${history.oldStatus ?? '-'} → '
                      '${history.newStatus ?? '-'}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],

                  const SizedBox(height: 8),

                  Text(
                    _formatDate(history.createdAt),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatEvent(String event) {
    if (event.isEmpty) {
      return 'Signal Update';
    }

    return event
        .split('_')
        .map(
          (word) =>
              word.isEmpty
                  ? word
                  : '${word[0].toUpperCase()}'
                    '${word.substring(1)}',
        )
        .join(' ');
  }

  String _formatDate(DateTime date) {
    final localDate = date.toLocal();

    final hour = localDate.hour
        .toString()
        .padLeft(2, '0');

    final minute = localDate.minute
        .toString()
        .padLeft(2, '0');

    return '${localDate.day}/'
        '${localDate.month}/'
        '${localDate.year} '
        '$hour:$minute';
  }
}
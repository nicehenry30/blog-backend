import 'dart:async';

import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime targetTime;

  const CountdownTimer({
    super.key,
    required this.targetTime,
  });

  @override
  State<CountdownTimer> createState() =>
      _CountdownTimerState();
}

class _CountdownTimerState
    extends State<CountdownTimer> {
  late Duration remaining;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    remaining = widget.targetTime.difference(
      DateTime.now(),
    );

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (!mounted) return;

        setState(() {
          remaining = widget.targetTime.difference(
            DateTime.now(),
          );

          if (remaining.isNegative) {
            timer?.cancel();
          }
        });
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String _format(Duration duration) {
    if (duration.isNegative) {
      return 'Released';
    }

    final hours = duration.inHours
        .toString()
        .padLeft(2, '0');

    final minutes = (duration.inMinutes % 60)
        .toString()
        .padLeft(2, '0');

    final seconds = (duration.inSeconds % 60)
        .toString()
        .padLeft(2, '0');

    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.schedule,
          size: 18,
          color: Colors.blue,
        ),

        const SizedBox(width: 6),

        Text(
          _format(remaining),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}
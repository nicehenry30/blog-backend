import 'package:flutter/material.dart';

class ConfluenceChip extends StatelessWidget {
  final String title;

  const ConfluenceChip({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(Icons.check_circle, color: Colors.green, size: 18),
      label: Text(title),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}

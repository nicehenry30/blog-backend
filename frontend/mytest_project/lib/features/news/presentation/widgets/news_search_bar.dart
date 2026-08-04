import 'package:flutter/material.dart';

class NewsSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const NewsSearchBar({
    super.key,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: "Search news...",
        prefixIcon: const Icon(
          Icons.search,
        ),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(14),
        ),
      ),
    );
  }
}
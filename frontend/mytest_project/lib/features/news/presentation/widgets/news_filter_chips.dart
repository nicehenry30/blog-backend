import 'package:flutter/material.dart';

class NewsFilterChips extends StatelessWidget {
  final int selectedIndex;

  final ValueChanged<int> onSelected;

  const NewsFilterChips({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  static const filters = [
    "All",
    "High",
    "Medium",
    "Low",
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child:ListView.separated(
  scrollDirection: Axis.horizontal,
  itemCount: filters.length,
  separatorBuilder: (context, index) =>
      const SizedBox(width: 8),
  itemBuilder: (context, index) {
    return ChoiceChip(
      label: Text(filters[index]),
      selected: selectedIndex == index,
      onSelected: (_) => onSelected(index),
    );
  },
),
);
  }
}
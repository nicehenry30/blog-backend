import 'package:flutter/material.dart';

class EducationCourse {
  final String title;
  final String description;
  final String category;
  final IconData icon;
  final double progress;
  final bool isPremium;
  final int lessons;

  const EducationCourse({
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    required this.progress,
    required this.isPremium,
    required this.lessons,
  });
}
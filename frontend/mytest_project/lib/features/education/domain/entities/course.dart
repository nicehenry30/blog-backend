import 'lesson.dart';

class Course {
  final int id;
  final String title;
  final String? description;
  final String? thumbnail;
  final String? slug;
  final String? category;
  final String? level;
  final bool isPublished;
  final int sortOrder;
  final List<Lesson> lessons;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.slug,
    required this.category,
    required this.level,
    required this.isPublished,
    required this.sortOrder,
    required this.lessons,
  });
}
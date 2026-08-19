import '../../domain/entities/course.dart';
import 'lesson_model.dart';

class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.title,
    required super.description,
    required super.thumbnail,
    required super.slug,
    required super.category,
    required super.level,
    required super.isPublished,
    required super.sortOrder,
    required super.lessons,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    final lessonsJson = json['lessons'] as List<dynamic>?;

    return CourseModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      thumbnail: json['thumbnail'] as String?,
      slug: json['slug'] as String?,
      category: json['category'] as String?,
      level: json['level'] as String?,
      isPublished: json['is_published'] as bool? ?? false,
      sortOrder: json['sort_order'] as int? ?? 0,
      lessons: lessonsJson == null
          ? const []
          : lessonsJson
              .map(
                (lesson) => LessonModel.fromJson(
                  lesson as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'slug': slug,
      'category': category,
      'level': level,
      'is_published': isPublished,
      'sort_order': sortOrder,
      'lessons': lessons
          .map(
            (lesson) => (lesson as LessonModel).toJson(),
          )
          .toList(),
    };
  }
}
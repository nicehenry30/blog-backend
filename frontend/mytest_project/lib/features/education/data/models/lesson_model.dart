import '../../domain/entities/lesson.dart';

class LessonModel extends Lesson {
  const LessonModel({
    required super.id,
    required super.courseId,
    required super.title,
    required super.description,
    required super.videoUrl,
    required super.lessonOrder,
    required super.isPublished,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as int,
      courseId: json['course_id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      videoUrl: json['video_url'] as String?,
      lessonOrder: json['lesson_order'] as int? ?? 0,
      isPublished: json['is_published'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'description': description,
      'video_url': videoUrl,
      'lesson_order': lessonOrder,
      'is_published': isPublished,
    };
  }
}
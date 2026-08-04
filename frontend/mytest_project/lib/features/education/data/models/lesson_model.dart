import '../../domain/entities/lesson.dart';

class LessonModel extends Lesson {
  const LessonModel({
    required super.id,
    required super.courseId,
    required super.title,
    required super.description,
    required super.videoUrl,
    required super.order,
    required super.completed,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'],
      courseId: json['course_id'],
      title: json['title'],
      description: json['description'],
      videoUrl: json['video_url'],
      order: json['order'],
      completed: json['completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'description': description,
      'video_url': videoUrl,
      'order': order,
      'completed': completed,
    };
  }
}
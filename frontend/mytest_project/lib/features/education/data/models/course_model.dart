import '../../domain/entities/course.dart';

class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.title,
    required super.description,
    required super.thumbnail,
    required super.instructor,
    required super.lessonsCount,
    required super.progress,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      thumbnail: json['thumbnail'],
      instructor: json['instructor'],
      lessonsCount: json['lessons_count'],
      progress: (json['progress'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'instructor': instructor,
      'lessons_count': lessonsCount,
      'progress': progress,
    };
  }
}
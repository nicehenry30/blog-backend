import '../../domain/entities/progress.dart';

class ProgressModel extends Progress {
  const ProgressModel({
    required super.courseId,
    required super.completedLessons,
    required super.totalLessons,
    required super.percentage,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      courseId: json['course_id'],
      completedLessons: json['completed_lessons'],
      totalLessons: json['total_lessons'],
      percentage: (json['percentage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_id': courseId,
      'completed_lessons': completedLessons,
      'total_lessons': totalLessons,
      'percentage': percentage,
    };
  }
}
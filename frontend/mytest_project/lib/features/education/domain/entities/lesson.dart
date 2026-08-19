class Lesson {
  final int id;
  final int courseId;
  final String title;
  final String? description;
  final String? videoUrl;
  final int lessonOrder;
  final bool isPublished;

  const Lesson({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.lessonOrder,
    required this.isPublished,
  });
}
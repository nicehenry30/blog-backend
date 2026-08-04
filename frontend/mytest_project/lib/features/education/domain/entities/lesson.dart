class Lesson {
  final int id;
  final int courseId;
  final String title;
  final String description;
  final String videoUrl;
  final int order;
  final bool completed;

  const Lesson({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.order,
    required this.completed,
  });
}
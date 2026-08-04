class Course {
  final int id;
  final String title;
  final String description;
  final String thumbnail;
  final String instructor;
  final int lessonsCount;
  final double progress;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.instructor,
    required this.lessonsCount,
    required this.progress,
  });
}
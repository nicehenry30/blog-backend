class Progress {
  final int courseId;
  final int completedLessons;
  final int totalLessons;
  final double percentage;

  const Progress({
    required this.courseId,
    required this.completedLessons,
    required this.totalLessons,
    required this.percentage,
  });
}
part of 'education_bloc.dart';

@immutable
sealed class EducationEvent {}

final class LoadCourses extends EducationEvent {}

final class LoadCourseDetails extends EducationEvent {
  final int courseId;

  LoadCourseDetails(this.courseId);
}

final class LoadLessons extends EducationEvent {
  final int courseId;

  LoadLessons(this.courseId);
}

final class LoadProgress extends EducationEvent {
  final int courseId;

  LoadProgress(this.courseId);
}

final class CompleteLesson extends EducationEvent {
  final int lessonId;

  CompleteLesson(this.lessonId);
}
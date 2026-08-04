part of 'education_bloc.dart';

@immutable
sealed class EducationState {}

final class EducationInitial extends EducationState {}

final class EducationLoading extends EducationState {}

final class EducationLoaded extends EducationState {
  final List<Course> courses;

  EducationLoaded(this.courses);
}

final class EducationFailure extends EducationState {
  final String message;

  EducationFailure(this.message);
}
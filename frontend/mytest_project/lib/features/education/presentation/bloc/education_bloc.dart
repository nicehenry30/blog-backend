import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';

import '../../domain/entities/course.dart';
import '../../domain/entities/lesson.dart';

import '../../domain/usecases/get_courses.dart';
import '../../domain/usecases/get_course_details.dart';
import '../../domain/usecases/get_lessons.dart';

part 'education_event.dart';
part 'education_state.dart';

class EducationBloc
    extends Bloc<EducationEvent, EducationState> {
  final GetCourses getCourses;
  final GetCourseDetails getCourseDetails;
  final GetLessons getLessons;

  EducationBloc({
    required this.getCourses,
    required this.getCourseDetails,
    required this.getLessons,
  }) : super(EducationInitial()) {
    on<LoadCourses>(_onLoadCourses);
    on<LoadCourseDetails>(_onLoadCourseDetails);
    on<LoadLessons>(_onLoadLessons);
  }

  Future<void> _onLoadCourses(
    LoadCourses event,
    Emitter<EducationState> emit,
  ) async {
    emit(EducationLoading());

    final result = await getCourses(
      NoParams(),
    );

    result.fold(
      (failure) => emit(
        EducationFailure(failure.message),
      ),
      (courses) => emit(
        EducationLoaded(courses),
      ),
    );
  }

  Future<void> _onLoadCourseDetails(
    LoadCourseDetails event,
    Emitter<EducationState> emit,
  ) async {
    emit(EducationLoading());

    final result = await getCourseDetails(
      event.courseId,
    );

    result.fold(
      (failure) => emit(
        EducationFailure(failure.message),
      ),
      (course) => emit(
        EducationCourseDetailsLoaded(course),
      ),
    );
  }

  Future<void> _onLoadLessons(
    LoadLessons event,
    Emitter<EducationState> emit,
  ) async {
    emit(EducationLoading());

    final result = await getLessons(
      event.courseId,
    );

    result.fold(
      (failure) => emit(
        EducationFailure(failure.message),
      ),
      (lessons) => emit(
        EducationLessonsLoaded(lessons),
      ),
    );
  }
}
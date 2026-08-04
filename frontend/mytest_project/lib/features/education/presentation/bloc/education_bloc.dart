import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/course.dart';
import '../../domain/usecases/get_courses.dart';

import '../../../../core/usecase/usecase.dart';

part 'education_event.dart';
part 'education_state.dart';



class EducationBloc extends Bloc<EducationEvent, EducationState> {
  final GetCourses getCourses;

  EducationBloc({
    required this.getCourses,
  }) : super(EducationInitial()) {
    on<LoadCourses>(_onLoadCourses);
  }

  Future<void> _onLoadCourses(
    LoadCourses event,
    Emitter<EducationState> emit,
  ) async {
    emit(EducationLoading());

    final result =
        await getCourses(NoParams());

    result.fold(
      (failure) => emit(
        EducationFailure(
          failure.message,
        ),
      ),
      (courses) => emit(
        EducationLoaded(courses),
      ),
    );
  }
}
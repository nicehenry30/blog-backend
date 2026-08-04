import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

import '../entities/course.dart';
import '../repository/education_repository.dart';

class GetCourseDetails implements UseCase<Course, int> {
  final EducationRepository repository;

  GetCourseDetails(this.repository);

  @override
  Future<Either<Failure, Course>> call(int courseId) {
    return repository.getCourseDetails(courseId);
  }
}
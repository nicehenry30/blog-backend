import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

import '../entities/course.dart';
import '../repository/education_repository.dart';

class GetCourses implements UseCase<List<Course>, NoParams> {
  final EducationRepository repository;

  GetCourses(this.repository);

  @override
  Future<Either<Failure, List<Course>>> call(NoParams params) {
    return repository.getCourses();
  }
}
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

import '../entities/lesson.dart';
import '../repository/education_repository.dart';

class GetLessons implements UseCase<List<Lesson>, int> {
  final EducationRepository repository;

  GetLessons(this.repository);

  @override
  Future<Either<Failure, List<Lesson>>> call(int courseId) {
    return repository.getLessons(courseId);
  }
}
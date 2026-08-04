import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

import '../entities/progress.dart';
import '../repository/education_repository.dart';

class GetProgress implements UseCase<Progress, int> {
  final EducationRepository repository;

  GetProgress(this.repository);

  @override
  Future<Either<Failure, Progress>> call(int courseId) {
    return repository.getProgress(courseId);
  }
}
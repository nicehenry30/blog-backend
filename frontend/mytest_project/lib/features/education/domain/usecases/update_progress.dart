import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

import '../repository/education_repository.dart';

class UpdateProgress implements UseCase<void, int> {
  final EducationRepository repository;

  UpdateProgress(this.repository);

  @override
  Future<Either<Failure, void>> call(int lessonId) {
    return repository.updateProgress(lessonId);
  }
}
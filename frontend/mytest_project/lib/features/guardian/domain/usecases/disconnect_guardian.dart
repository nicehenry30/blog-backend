import 'package:fpdart/fpdart.dart';

import 'package:mytest_project/core/error/failures.dart';
import 'package:mytest_project/core/usecase/usecase.dart';
import 'package:mytest_project/features/guardian/domain/repository/guardian_repository.dart';

class DisconnectGuardian
    implements UseCase<void, NoParams> {
  final GuardianRepository repository;

  DisconnectGuardian(
    this.repository,
  );

  @override
  Future<Either<Failure, void>> call(
    NoParams params,
  ) async {
    return await repository.disconnectGuardian();
  }
}
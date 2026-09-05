import 'package:fpdart/fpdart.dart';

import 'package:mytest_project/core/error/failures.dart';

import 'package:mytest_project/core/usecase/usecase.dart';

import 'package:mytest_project/features/guardian/domain/repository/guardian_repository.dart';

class DisconnectGuardian
    implements UseCase<void, String> {

  final GuardianRepository repository;

  DisconnectGuardian(
    this.repository,
  );

  @override
  Future<Either<Failure, void>> call(
    String platform,
  ) async {

    return await repository.disconnectGuardian(platform);
  }
}
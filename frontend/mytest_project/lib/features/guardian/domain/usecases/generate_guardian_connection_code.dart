import 'package:fpdart/fpdart.dart';

import 'package:mytest_project/core/error/failures.dart';
import 'package:mytest_project/core/usecase/usecase.dart';

import 'package:mytest_project/features/guardian/domain/repository/guardian_repository.dart';

class GenerateGuardianConnectionCode
    implements UseCase<String, String> {
  final GuardianRepository repository;

  GenerateGuardianConnectionCode(
    this.repository,
  );

  @override
  Future<Either<Failure, String>> call(
    String platform,
  ) {
    return repository.generateConnectionCode(
      platform,
    );
  }
}
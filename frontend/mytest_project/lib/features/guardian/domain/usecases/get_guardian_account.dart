import 'package:fpdart/fpdart.dart';

import 'package:mytest_project/core/error/failures.dart';

import 'package:mytest_project/core/usecase/usecase.dart';

import 'package:mytest_project/features/guardian/domain/entities/guardian_account.dart';

import 'package:mytest_project/features/guardian/domain/repository/guardian_repository.dart';

class GetGuardianAccount
    implements UseCase<GuardianAccount, String> {

  final GuardianRepository repository;

  GetGuardianAccount(this.repository);

  @override
  Future<Either<Failure, GuardianAccount>> call(
    String platform,
  ) {
    return repository.getGuardianAccount(
      platform,
    );
  }
}
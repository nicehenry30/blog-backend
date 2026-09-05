import 'package:fpdart/fpdart.dart';

import 'package:mytest_project/core/error/failures.dart';

import 'package:mytest_project/features/guardian/domain/entities/guardian_account.dart';

abstract interface class GuardianRepository {
  Future<Either<Failure, GuardianAccount>>
      getGuardianAccount(
    String platform,
  );

  Future<Either<Failure, String>>
      generateConnectionCode(
    String platform,
  );

  Future<Either<Failure, void>>
      disconnectGuardian(
    String platform,
  );
}
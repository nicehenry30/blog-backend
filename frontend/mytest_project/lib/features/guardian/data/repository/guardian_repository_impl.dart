import 'package:fpdart/fpdart.dart';

import 'package:mytest_project/core/error/exceptions.dart';
import 'package:mytest_project/core/error/failures.dart';

import 'package:mytest_project/features/guardian/data/datasources/guardian_remote_data_source.dart';
import 'package:mytest_project/features/guardian/domain/entities/guardian_account.dart';
import 'package:mytest_project/features/guardian/domain/repository/guardian_repository.dart';

class GuardianRepositoryImpl
    implements GuardianRepository {
  final GuardianRemoteDataSource remoteDataSource;

  GuardianRepositoryImpl(
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, GuardianAccount>>
      getGuardianAccount(
    String platform,
  ) async {
    try {
      final account =
          await remoteDataSource.getGuardianAccount(
        platform,
      );

      return Right(account);
    } on ServerException catch (e) {
      return Left(
        Failure(e.message),
      );
    } catch (e) {
      return Left(
        Failure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, String>>
      generateConnectionCode(
    String platform,
  ) async {
    try {
      final code =
          await remoteDataSource.generateConnectionCode(
        platform,
      );

      return Right(code);
    } on ServerException catch (e) {
      return Left(
        Failure(e.message),
      );
    } catch (e) {
      return Left(
        Failure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, void>>
      disconnectGuardian(
    String platform,
  ) async {
    try {
      await remoteDataSource.disconnectGuardian(
        platform,
      );

      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        Failure(e.message),
      );
    } catch (e) {
      return Left(
        Failure(e.toString()),
      );
    }
  }
}
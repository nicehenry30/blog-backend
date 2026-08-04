import 'package:fpdart/fpdart.dart';

import 'package:mytest_project/core/error/exceptions.dart';
import 'package:mytest_project/core/error/failures.dart';

import 'package:mytest_project/features/risk_settings/data/datasources/risk_settings_remote_data_source.dart';
import 'package:mytest_project/features/risk_settings/domain/entities/risk_settings.dart';
import 'package:mytest_project/features/risk_settings/domain/repository/risk_settings_repository.dart';

class RiskSettingsRepositoryImpl
    implements RiskSettingsRepository {
  final RiskSettingsRemoteDataSource remoteDataSource;

  RiskSettingsRepositoryImpl(
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, RiskSettings>>
      getRiskSettings() async {
    try {
      final settings =
          await remoteDataSource.getRiskSettings();

      return Right(settings);
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
  Future<Either<Failure, RiskSettings>>
      updateRiskSettings(
    RiskSettings settings,
  ) async {
    try {
      final updatedSettings =
          await remoteDataSource.updateRiskSettings(
        settings,
      );

      return Right(updatedSettings);
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
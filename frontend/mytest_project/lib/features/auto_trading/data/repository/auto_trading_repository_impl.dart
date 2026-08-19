import 'package:fpdart/fpdart.dart';

import 'package:mytest_project/core/error/exceptions.dart';
import 'package:mytest_project/core/error/failures.dart';
import 'package:mytest_project/features/auto_trading/data/datasources/auto_trading_remote_data_source.dart';
import 'package:mytest_project/features/auto_trading/domain/entities/auto_trading_settings.dart';
import 'package:mytest_project/features/auto_trading/domain/repository/auto_trading_repository.dart';

class AutoTradingRepositoryImpl
    implements AutoTradingRepository {
  final AutoTradingRemoteDataSource remoteDataSource;

  AutoTradingRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AutoTradingSettings>>
      getAutoTradingSettings() async {
    try {
      final settings =
          await remoteDataSource.getAutoTradingSettings();

      return Right(settings);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AutoTradingSettings>>
      updateAutoTrading(
    bool enabled,
  ) async {
    try {
      final settings =
          await remoteDataSource.updateAutoTrading(enabled);

      return Right(settings);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AutoTradingSettings>>
      updateAutoTradingPreferences({
    double? minimumSignalQuality,
    double? minimumAiConfidence,
    bool? allowBuy,
    bool? allowSell,
    bool? requireAiConfirmation,
    bool? requireStopLoss,
    bool? requireTakeProfit,
  }) async {
    try {
      final settings =
          await remoteDataSource.updateAutoTradingPreferences(
        minimumSignalQuality: minimumSignalQuality,
        minimumAiConfidence: minimumAiConfidence,
        allowBuy: allowBuy,
        allowSell: allowSell,
        requireAiConfirmation: requireAiConfirmation,
        requireStopLoss: requireStopLoss,
        requireTakeProfit: requireTakeProfit,
      );

      return Right(settings);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
import 'package:fpdart/fpdart.dart';

import 'package:mytest_project/core/error/exceptions.dart';
import 'package:mytest_project/core/error/failures.dart';

import 'package:mytest_project/features/market_alerts/data/datasources/market_alert_remote_data_source.dart';
import 'package:mytest_project/features/market_alerts/domain/entities/market_alert.dart';
import 'package:mytest_project/features/market_alerts/domain/repositories/market_alert_repository.dart';

class MarketAlertRepositoryImpl
    implements MarketAlertRepository {
  final MarketAlertRemoteDataSource remoteDataSource;

  MarketAlertRepositoryImpl(
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, List<MarketAlert>>>
      getMarketAlerts() async {
    try {
      final alerts =
          await remoteDataSource.getMarketAlerts();

      return Right(alerts);
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
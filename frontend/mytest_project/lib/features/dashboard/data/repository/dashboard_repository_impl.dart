import 'package:fpdart/fpdart.dart';

import 'package:mytest_project/core/error/exceptions.dart';
import 'package:mytest_project/core/error/failures.dart';

import 'package:mytest_project/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:mytest_project/features/dashboard/domain/entities/dashboard.dart';
import 'package:mytest_project/features/dashboard/domain/repository/dashboard_repository.dart';

class DashboardRepositoryImpl
    implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl(
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, Dashboard>>
      getDashboard() async {
    try {
      final dashboard =
          await remoteDataSource.getDashboard();

      return Right(dashboard);
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
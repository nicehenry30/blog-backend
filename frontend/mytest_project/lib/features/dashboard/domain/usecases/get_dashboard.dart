import 'package:fpdart/fpdart.dart';

import 'package:mytest_project/core/error/failures.dart';
import 'package:mytest_project/core/usecase/usecase.dart';

import 'package:mytest_project/features/dashboard/domain/entities/dashboard.dart';
import 'package:mytest_project/features/dashboard/domain/repository/dashboard_repository.dart';

class GetDashboard
    implements UseCase<Dashboard, NoParams> {
  final DashboardRepository repository;

  GetDashboard(this.repository);

  @override
  Future<Either<Failure, Dashboard>> call(
    NoParams params,
  ) {
    return repository.getDashboard();
  }
}
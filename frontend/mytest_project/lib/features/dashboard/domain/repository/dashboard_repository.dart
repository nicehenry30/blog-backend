import 'package:fpdart/fpdart.dart';

import 'package:mytest_project/core/error/failures.dart';
import 'package:mytest_project/features/dashboard/domain/entities/dashboard.dart';

abstract interface class DashboardRepository {
  Future<Either<Failure, Dashboard>> getDashboard();
}
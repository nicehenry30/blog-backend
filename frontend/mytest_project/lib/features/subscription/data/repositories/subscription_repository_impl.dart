import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';

import '../../domain/entities/plan.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';

import '../datasources/subscription_remote_data_source.dart';

class SubscriptionRepositoryImpl
    implements SubscriptionRepository {
  final SubscriptionRemoteDataSource remoteDataSource;

  SubscriptionRepositoryImpl(
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, List<Plan>>> getPlans() async {
    try {
      final result =
          await remoteDataSource.getPlans();

      return right(result);
    } on ServerException catch (e) {
      return left(
        Failure(e.message),
      );
    }
  }

  @override
  Future<Either<Failure, Subscription>>
      getCurrentSubscription() async {
    try {
      final result =
          await remoteDataSource
              .getCurrentSubscription();

      return right(result);
    } on ServerException catch (e) {
      return left(
        Failure(e.message),
      );
    }
  }

  @override
  Future<Either<Failure, String>>
      initializePayment(
    int planId,
  ) async {
    try {
      final result =
          await remoteDataSource
              .initializePayment(planId);

      return right(result);
    } on ServerException catch (e) {
      return left(
        Failure(e.message),
      );
    }
  }

  @override
  Future<Either<Failure, Subscription>>
      verifyPayment(
    String reference,
  ) async {
    try {
      final result =
          await remoteDataSource
              .verifyPayment(reference);

      return right(result);
    } on ServerException catch (e) {
      return left(
        Failure(e.message),
      );
    }
  }
}
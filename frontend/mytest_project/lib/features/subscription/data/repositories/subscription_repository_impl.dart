import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';

import '../../domain/entities/crypto_payment.dart';
import '../../domain/entities/plan.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/entities/payment_initialization.dart';

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
  Future<Either<Failure, PaymentInitialization>>
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
  Future<Either<Failure, CryptoPayment>>
      initializeCryptoPayment(
    int planId,
  ) async {
    try {
      final result =
          await remoteDataSource
              .initializeCryptoPayment(
        planId,
      );

      return right(result);
    } on ServerException catch (e) {
      return left(
        Failure(e.message),
      );
    }
  }

  @override
  Future<Either<Failure, void>>
      submitCryptoTransaction(
    int paymentId,
    String transactionHash,
  ) async {
    try {
      await remoteDataSource
          .submitCryptoTransaction(
        paymentId,
        transactionHash,
      );

      return right(null);
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

  @override
  Future<Either<Failure, Subscription>>
      startTrial(
    int planId,
    String paymentProvider,
    String paymentMethodId,
  ) async {
    try {
      final result =
          await remoteDataSource.startTrial(
        planId,
        paymentProvider,
        paymentMethodId,
      );

      return right(result);
    } on ServerException catch (e) {
      return left(
        Failure(e.message),
      );
    }
  }
}
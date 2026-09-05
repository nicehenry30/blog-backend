import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';

import '../entities/crypto_payment.dart';
import '../entities/plan.dart';
import '../entities/subscription.dart';
import '../entities/payment_initialization.dart';

abstract interface class SubscriptionRepository {
  Future<Either<Failure, List<Plan>>> getPlans();

  Future<Either<Failure, Subscription>>
      getCurrentSubscription();

  Future<Either<Failure, PaymentInitialization>>
      initializePayment(
    int planId,
  );

  Future<Either<Failure, CryptoPayment>>
      initializeCryptoPayment(
    int planId,
  );

  Future<Either<Failure, void>>
      submitCryptoTransaction(
    int paymentId,
    String transactionHash,
  );

  Future<Either<Failure, Subscription>>
      verifyPayment(
    String reference,
  );

  /// Start the user's free trial.
  Future<Either<Failure, Subscription>>
      startTrial(
    int planId,
    String paymentProvider,
    String paymentMethodId,
  );
}
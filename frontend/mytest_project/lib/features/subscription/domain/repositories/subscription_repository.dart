import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';

import '../entities/plan.dart';
import '../entities/subscription.dart';

abstract interface class SubscriptionRepository {
  Future<Either<Failure, List<Plan>>> getPlans();

  Future<Either<Failure, Subscription>>
      getCurrentSubscription();

  Future<Either<Failure, String>>
      initializePayment(
    int planId,
  );

  // 👇 NEW METHOD
  Future<Either<Failure, Subscription>>
      verifyPayment(
    String reference,
  );
}
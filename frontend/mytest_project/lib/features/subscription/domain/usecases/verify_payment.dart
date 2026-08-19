import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/subscription.dart';
import '../repositories/subscription_repository.dart';

class VerifyPayment {
  final SubscriptionRepository repository;

  VerifyPayment(this.repository);

  Future<Either<Failure, Subscription>> call(
    String reference,
  ) {
    return repository.verifyPayment(
      reference,
    );
  }
}
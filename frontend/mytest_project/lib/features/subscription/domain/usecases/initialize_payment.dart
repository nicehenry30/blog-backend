import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../repositories/subscription_repository.dart';

class InitializePayment {
  final SubscriptionRepository repository;

  InitializePayment(this.repository);

  Future<Either<Failure, String>> call(
    int planId,
  ) {
    return repository.initializePayment(
      planId,
    );
  }
}
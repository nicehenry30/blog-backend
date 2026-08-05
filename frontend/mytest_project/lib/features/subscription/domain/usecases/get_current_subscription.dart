import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/subscription.dart';
import '../repositories/subscription_repository.dart';

class GetCurrentSubscription {
  final SubscriptionRepository repository;

  GetCurrentSubscription(this.repository);

  Future<Either<Failure, Subscription>> call() async {
    return repository.getCurrentSubscription();
  }
}
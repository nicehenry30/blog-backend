import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/plan.dart';
import '../repositories/subscription_repository.dart';

class GetPlans {
  final SubscriptionRepository repository;

  GetPlans(this.repository);

  Future<Either<Failure, List<Plan>>> call() {
    return repository.getPlans();
  }
}
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';

import '../entities/crypto_payment.dart';
import '../repositories/subscription_repository.dart';

class InitializeCryptoPayment {
  final SubscriptionRepository repository;

  InitializeCryptoPayment(this.repository);

  Future<Either<Failure, CryptoPayment>> call(
    int planId,
  ) {
    return repository.initializeCryptoPayment(
      planId,
    );
  }
}
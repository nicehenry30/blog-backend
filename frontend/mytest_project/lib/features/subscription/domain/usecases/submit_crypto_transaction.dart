import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';

import '../repositories/subscription_repository.dart';

class SubmitCryptoTransaction {
  final SubscriptionRepository repository;

  SubmitCryptoTransaction(this.repository);

  Future<Either<Failure, void>> call(
    int paymentId,
    String transactionHash,
  ) {
    return repository.submitCryptoTransaction(
      paymentId,
      transactionHash,
    );
  }
}
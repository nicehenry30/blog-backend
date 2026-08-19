import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';

import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class GetPayment {
  final PaymentRepository repository;

  GetPayment(
    this.repository,
  );

  Future<Either<Failure, Payment>>
      call(
    int paymentId,
  ) {
    return repository.getPayment(
      paymentId,
    );
  }
}
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';

import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class GetPayments {
  final PaymentRepository repository;

  GetPayments(
    this.repository,
  );

  Future<Either<Failure, List<Payment>>>
      call() {
    return repository.getPayments();
  }
}
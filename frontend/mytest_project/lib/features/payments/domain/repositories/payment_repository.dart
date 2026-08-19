import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';

import '../entities/payment.dart';

abstract interface class PaymentRepository {
  Future<Either<Failure, List<Payment>>> getPayments();

  Future<Either<Failure, Payment>> getPayment(
    int paymentId,
  );
}
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';

import '../../domain/entities/payment.dart';
import '../../domain/repositories/payment_repository.dart';

import '../datasources/payment_remote_data_source.dart';

class PaymentRepositoryImpl
    implements PaymentRepository {
  final PaymentRemoteDataSource
      remoteDataSource;

  PaymentRepositoryImpl(
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, List<Payment>>>
      getPayments() async {
    try {
      final result =
          await remoteDataSource
              .getPayments();

      return right(result);
    } on ServerException catch (e) {
      return left(
        Failure(e.message),
      );
    }
  }

  @override
  Future<Either<Failure, Payment>>
      getPayment(
    int paymentId,
  ) async {
    try {
      final result =
          await remoteDataSource
              .getPayment(paymentId);

      return right(result);
    } on ServerException catch (e) {
      return left(
        Failure(e.message),
      );
    }
  }
}
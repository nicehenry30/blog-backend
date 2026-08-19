import '../models/payment_model.dart';

abstract interface class PaymentRemoteDataSource {
  Future<List<PaymentModel>> getPayments();

  Future<PaymentModel> getPayment(
    int paymentId,
  );
}
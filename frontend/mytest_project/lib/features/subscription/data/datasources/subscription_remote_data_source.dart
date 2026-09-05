import '../../domain/entities/payment_initialization.dart';

import '../models/crypto_payment_model.dart';
import '../models/plan_model.dart';
import '../models/subscription_model.dart';

abstract interface class SubscriptionRemoteDataSource {
  Future<List<PlanModel>> getPlans();

  Future<SubscriptionModel> getCurrentSubscription();

  Future<PaymentInitialization> initializePayment(
    int planId,
  );

  Future<CryptoPaymentModel> initializeCryptoPayment(
    int planId,
  );

  Future<void> submitCryptoTransaction(
    int paymentId,
    String transactionHash,
  );

  Future<SubscriptionModel> verifyPayment(
    String reference,
  );

  Future<SubscriptionModel> startTrial(
    int planId,
    String paymentProvider,
    String paymentMethodId,
  );
}
part of 'subscription_bloc.dart';

abstract class SubscriptionEvent {}

class LoadSubscription extends SubscriptionEvent {}

class InitializeSubscriptionPayment
    extends SubscriptionEvent {
  final int planId;

  InitializeSubscriptionPayment(
    this.planId,
  );
}

class InitializeCryptoSubscriptionPayment
    extends SubscriptionEvent {
  final int planId;

  InitializeCryptoSubscriptionPayment(
    this.planId,
  );
}

class SubmitSubscriptionCryptoTransaction
    extends SubscriptionEvent {
  final int paymentId;
  final String transactionHash;

  SubmitSubscriptionCryptoTransaction({
    required this.paymentId,
    required this.transactionHash,
  });
}

class VerifySubscriptionPayment
    extends SubscriptionEvent {
  final String reference;

  VerifySubscriptionPayment(
    this.reference,
  );
}

/// Start the user's 7-day free trial.
class StartSubscriptionTrial
    extends SubscriptionEvent {
  final int planId;
  final String paymentProvider;
  final String paymentMethodId;

  StartSubscriptionTrial({
    required this.planId,
    required this.paymentProvider,
    required this.paymentMethodId,
  });
}
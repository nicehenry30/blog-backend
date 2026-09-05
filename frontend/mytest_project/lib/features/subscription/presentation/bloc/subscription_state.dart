part of 'subscription_bloc.dart';

abstract class SubscriptionState {}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final List<Plan> plans;

  final Subscription? currentSubscription;

  SubscriptionLoaded({
    required this.plans,
    required this.currentSubscription,
  });
}

class SubscriptionPaymentReady
    extends SubscriptionState {
  final PaymentInitialization payment;

  SubscriptionPaymentReady(
    this.payment,
  );
}

class SubscriptionCryptoPaymentReady
    extends SubscriptionState {
  final CryptoPayment payment;

  SubscriptionCryptoPaymentReady(
    this.payment,
  );
}

class SubscriptionCryptoSubmitting
    extends SubscriptionState {}

class SubscriptionCryptoPaymentSubmitted
    extends SubscriptionState {
  final String message;

  SubscriptionCryptoPaymentSubmitted({
    required this.message,
  });
}

class SubscriptionFailure
    extends SubscriptionState {
  final String message;

  SubscriptionFailure(this.message);
}
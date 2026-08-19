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

class VerifySubscriptionPayment
    extends SubscriptionEvent {
  final String reference;

  VerifySubscriptionPayment(
    this.reference,
  );
}
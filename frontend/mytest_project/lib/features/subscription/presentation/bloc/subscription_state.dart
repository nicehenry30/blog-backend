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
  final String authorizationUrl;

  SubscriptionPaymentReady(
    this.authorizationUrl,
  );
}

class SubscriptionFailure
    extends SubscriptionState {
  final String message;

  SubscriptionFailure(this.message);
}
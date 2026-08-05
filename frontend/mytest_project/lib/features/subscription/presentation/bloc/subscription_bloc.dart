import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/plan.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/usecases/get_current_subscription.dart';
import '../../domain/usecases/get_plans.dart';
import '../../domain/usecases/initialize_payment.dart';

//
// EVENTS
//

abstract class SubscriptionEvent {}

class LoadSubscription extends SubscriptionEvent {}

class InitializeSubscriptionPayment extends SubscriptionEvent {
  final int planId;

  InitializeSubscriptionPayment(this.planId);
}

//
// STATES
//

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

class SubscriptionPaymentReady extends SubscriptionState {
  final String authorizationUrl;

  SubscriptionPaymentReady(this.authorizationUrl);
}

class SubscriptionFailure extends SubscriptionState {
  final String message;

  SubscriptionFailure(this.message);
}

//
// BLOC
//

class SubscriptionBloc
    extends Bloc<SubscriptionEvent, SubscriptionState> {
  final GetPlans getPlans;
  final GetCurrentSubscription getCurrentSubscription;
  final InitializePayment initializePayment;

  SubscriptionBloc({
    required this.getPlans,
    required this.getCurrentSubscription,
    required this.initializePayment,
  }) : super(SubscriptionInitial()) {
    on<LoadSubscription>(_onLoadSubscription);
    on<InitializeSubscriptionPayment>(_onInitializePayment);
  }

  Future<void> _onLoadSubscription(
    LoadSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());

    final plansResult = await getPlans();

    final subscriptionResult = await getCurrentSubscription();

    plansResult.fold(
      (failure) {
        emit(
          SubscriptionFailure(
            failure.message,
          ),
        );
      },
      (plans) {
        subscriptionResult.fold(
          (_) {
            emit(
              SubscriptionLoaded(
                plans: plans,
                currentSubscription: null,
              ),
            );
          },
          (subscription) {
            emit(
              SubscriptionLoaded(
                plans: plans,
                currentSubscription: subscription,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onInitializePayment(
    InitializeSubscriptionPayment event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());

    final result = await initializePayment(
      event.planId,
    );

    result.fold(
      (failure) {
        emit(
          SubscriptionFailure(
            failure.message,
          ),
        );
      },
      (url) {
        emit(
          SubscriptionPaymentReady(
            url,
          ),
        );
      },
    );
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/plan.dart';
import '../../domain/entities/subscription.dart';

import '../../domain/usecases/get_current_subscription.dart';
import '../../domain/usecases/get_plans.dart';
import '../../domain/usecases/initialize_payment.dart';
import '../../domain/usecases/verify_payment.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc
    extends Bloc<SubscriptionEvent, SubscriptionState> {
  final GetPlans getPlans;

  final GetCurrentSubscription getCurrentSubscription;

  final InitializePayment initializePayment;

  final VerifyPayment verifyPayment;

  SubscriptionBloc({
    required this.getPlans,
    required this.getCurrentSubscription,
    required this.initializePayment,
    required this.verifyPayment,
  }) : super(SubscriptionInitial()) {
    on<LoadSubscription>(
      _onLoadSubscription,
    );

    on<InitializeSubscriptionPayment>(
      _onInitializePayment,
    );

    on<VerifySubscriptionPayment>(
      _onVerifyPayment,
    );
  }

  Future<void> _onLoadSubscription(
    LoadSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());

    final plansResult = await getPlans();

    final subscriptionResult =
        await getCurrentSubscription();

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

  Future<void> _onVerifyPayment(
    VerifySubscriptionPayment event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());

    final result = await verifyPayment(
      event.reference,
    );

    result.fold(
      (failure) {
        emit(
          SubscriptionFailure(
            failure.message,
          ),
        );
      },
      (subscription) async {
        final plansResult = await getPlans();

        plansResult.fold(
          (failure) {
            emit(
              SubscriptionFailure(
                failure.message,
              ),
            );
          },
          (plans) {
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
}
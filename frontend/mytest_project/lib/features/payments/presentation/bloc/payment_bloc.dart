import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/payment.dart';
import '../../domain/usecases/get_payment.dart';
import '../../domain/usecases/get_payments.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc
    extends Bloc<PaymentEvent, PaymentState> {
  final GetPayments getPayments;

  final GetPayment getPayment;

  PaymentBloc({
    required this.getPayments,
    required this.getPayment,
  }) : super(PaymentInitial()) {
    on<LoadPayments>(
      _onLoadPayments,
    );

    on<LoadPayment>(
      _onLoadPayment,
    );
  }

  Future<void> _onLoadPayments(
    LoadPayments event,
    Emitter<PaymentState> emit,
  ) async {
    emit(
      PaymentLoading(),
    );

    final result =
        await getPayments();

    result.fold(
      (failure) {
        emit(
          PaymentFailure(
            failure.message,
          ),
        );
      },
      (payments) {
        emit(
          PaymentsLoaded(
            payments,
          ),
        );
      },
    );
  }

  Future<void> _onLoadPayment(
    LoadPayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(
      PaymentLoading(),
    );

    final result =
        await getPayment(
      event.paymentId,
    );

    result.fold(
      (failure) {
        emit(
          PaymentFailure(
            failure.message,
          ),
        );
      },
      (payment) {
        emit(
          PaymentLoaded(
            payment,
          ),
        );
      },
    );
  }
}
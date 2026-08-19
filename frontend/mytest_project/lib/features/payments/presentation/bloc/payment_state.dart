part of 'payment_bloc.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentsLoaded extends PaymentState {
  final List<Payment> payments;

  PaymentsLoaded(this.payments);
}

class PaymentLoaded extends PaymentState {
  final Payment payment;

  PaymentLoaded(this.payment);
}

class PaymentFailure extends PaymentState {
  final String message;

  PaymentFailure(this.message);
}
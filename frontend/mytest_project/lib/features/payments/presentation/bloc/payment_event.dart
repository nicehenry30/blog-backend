part of 'payment_bloc.dart';

abstract class PaymentEvent {}

class LoadPayments extends PaymentEvent {}

class LoadPayment extends PaymentEvent {
  final int paymentId;

  LoadPayment(this.paymentId);
}
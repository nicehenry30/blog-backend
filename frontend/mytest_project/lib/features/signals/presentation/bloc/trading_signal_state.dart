part of 'trading_signal_bloc.dart';

sealed class TradingSignalState {}

final class TradingSignalInitial extends TradingSignalState {}

final class TradingSignalLoading extends TradingSignalState {}

final class TradingSignalLoaded extends TradingSignalState {
  final List<TradingSignal> signals;

  TradingSignalLoaded(this.signals);
}

final class TradingSignalDetailsLoaded extends TradingSignalState {
  final TradingSignal signal;

  TradingSignalDetailsLoaded(this.signal);
}

final class TradingSignalFailure extends TradingSignalState {
  final String message;

  TradingSignalFailure(this.message);
}

final class AiSignalConfirmationLoading extends TradingSignalState {}

final class AiSignalConfirmationLoaded extends TradingSignalState {
  final AiSignalConfirmation confirmation;

  AiSignalConfirmationLoaded(this.confirmation);
}

final class AiSignalConfirmationFailure extends TradingSignalState {
  final String message;

  AiSignalConfirmationFailure(this.message);
}
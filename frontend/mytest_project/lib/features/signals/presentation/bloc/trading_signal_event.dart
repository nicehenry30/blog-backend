part of 'trading_signal_bloc.dart';

sealed class TradingSignalEvent {}

final class LoadTradingSignals extends TradingSignalEvent {}

final class LoadTradingSignalDetails extends TradingSignalEvent {
  final int signalId;

  LoadTradingSignalDetails(this.signalId);
}
part of 'auto_trading_bloc.dart';

abstract class AutoTradingState {
  const AutoTradingState();
}

// ============================================================
// INITIAL
// ============================================================

class AutoTradingInitial extends AutoTradingState {
  const AutoTradingInitial();
}

// ============================================================
// LOADING
// ============================================================

class AutoTradingLoading extends AutoTradingState {
  const AutoTradingLoading();
}

// ============================================================
// LOADED
// ============================================================

class AutoTradingLoaded extends AutoTradingState {
  final AutoTradingSettings settings;

  const AutoTradingLoaded(this.settings);
}

// ============================================================
// UPDATING
// ============================================================

class AutoTradingUpdating extends AutoTradingState {
  final AutoTradingSettings settings;

  const AutoTradingUpdating({
    required this.settings,
  });
}

// ============================================================
// FAILURE
// ============================================================

class AutoTradingFailure extends AutoTradingState {
  final String message;
  final AutoTradingSettings? previousSettings;

  const AutoTradingFailure(
    this.message, {
    this.previousSettings,
  });
}
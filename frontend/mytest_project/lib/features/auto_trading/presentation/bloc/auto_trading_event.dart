part of 'auto_trading_bloc.dart';

abstract class AutoTradingEvent {
  const AutoTradingEvent();
}

// ============================================================
// LOAD SETTINGS
// ============================================================

class AutoTradingLoadRequested extends AutoTradingEvent {
  const AutoTradingLoadRequested();
}

// ============================================================
// MASTER AUTO TRADING SWITCH
// ============================================================

class AutoTradingChanged extends AutoTradingEvent {
  final bool enabled;

  const AutoTradingChanged(this.enabled);
}

// ============================================================
// AUTO TRADING PREFERENCES
// ============================================================

class AutoTradingPreferencesChanged extends AutoTradingEvent {
  final double? minimumSignalQuality;
  final double? minimumAiConfidence;

  final bool? allowBuy;
  final bool? allowSell;

  final bool? requireAiConfirmation;
  final bool? requireStopLoss;
  final bool? requireTakeProfit;

  const AutoTradingPreferencesChanged({
    this.minimumSignalQuality,
    this.minimumAiConfidence,
    this.allowBuy,
    this.allowSell,
    this.requireAiConfirmation,
    this.requireStopLoss,
    this.requireTakeProfit,
  });
}
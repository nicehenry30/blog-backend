class AutoTradingSettings {
  final bool enabled;

  final double minimumSignalQuality;
  final double minimumAiConfidence;

  final bool allowBuy;
  final bool allowSell;

  final bool requireAiConfirmation;
  final bool requireStopLoss;
  final bool requireTakeProfit;

  const AutoTradingSettings({
    required this.enabled,
    required this.minimumSignalQuality,
    required this.minimumAiConfidence,
    required this.allowBuy,
    required this.allowSell,
    required this.requireAiConfirmation,
    required this.requireStopLoss,
    required this.requireTakeProfit,
  });

  AutoTradingSettings copyWith({
    bool? enabled,
    double? minimumSignalQuality,
    double? minimumAiConfidence,
    bool? allowBuy,
    bool? allowSell,
    bool? requireAiConfirmation,
    bool? requireStopLoss,
    bool? requireTakeProfit,
  }) {
    return AutoTradingSettings(
      enabled: enabled ?? this.enabled,
      minimumSignalQuality:
          minimumSignalQuality ?? this.minimumSignalQuality,
      minimumAiConfidence:
          minimumAiConfidence ?? this.minimumAiConfidence,
      allowBuy: allowBuy ?? this.allowBuy,
      allowSell: allowSell ?? this.allowSell,
      requireAiConfirmation:
          requireAiConfirmation ?? this.requireAiConfirmation,
      requireStopLoss:
          requireStopLoss ?? this.requireStopLoss,
      requireTakeProfit:
          requireTakeProfit ?? this.requireTakeProfit,
    );
  }
}
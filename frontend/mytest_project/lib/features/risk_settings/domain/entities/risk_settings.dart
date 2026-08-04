class RiskSettings {
  final double riskPerTrade;
  final double dailyLossLimit;
  final double maxDrawdown;

  const RiskSettings({
    required this.riskPerTrade,
    required this.dailyLossLimit,
    required this.maxDrawdown,
  });

  const RiskSettings.defaultSettings()
      : riskPerTrade = 1.0,
        dailyLossLimit = 2.0,
        maxDrawdown = 5.0;

  RiskSettings copyWith({
    double? riskPerTrade,
    double? dailyLossLimit,
    double? maxDrawdown,
  }) {
    return RiskSettings(
      riskPerTrade: riskPerTrade ?? this.riskPerTrade,
      dailyLossLimit: dailyLossLimit ?? this.dailyLossLimit,
      maxDrawdown: maxDrawdown ?? this.maxDrawdown,
    );
  }
}
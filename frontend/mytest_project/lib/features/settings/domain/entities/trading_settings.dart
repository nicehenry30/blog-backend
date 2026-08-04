class TradingSettings {
  final String currencyCode;
  final String currencySymbol;
  final int decimalPlaces;

  const TradingSettings({
    required this.currencyCode,
    required this.currencySymbol,
    required this.decimalPlaces,
  });

  const TradingSettings.defaultSettings()
    : currencyCode = 'GBP',
      currencySymbol = '£',
      decimalPlaces = 5;

  TradingSettings copyWith({
    String? currencyCode,
    String? currencySymbol,
    int? decimalPlaces,
  }) {
    return TradingSettings(
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      decimalPlaces: decimalPlaces ?? this.decimalPlaces,
    );
  }
}

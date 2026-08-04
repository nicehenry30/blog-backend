
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mytest_project/features/settings/domain/entities/trading_settings.dart';

class TradingSettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  TradingSettingsLocalDataSource(this.sharedPreferences);

  static const String _currencyCodeKey = 'trading_currency_code';
  static const String _currencySymbolKey = 'trading_currency_symbol';
  static const String _decimalPlacesKey = 'trading_decimal_places';

  TradingSettings getSettings() {
    final currencyCode =
        sharedPreferences.getString(_currencyCodeKey);

    final currencySymbol =
        sharedPreferences.getString(_currencySymbolKey);

    final decimalPlaces =
        sharedPreferences.getInt(_decimalPlacesKey);

    return TradingSettings(
      currencyCode: currencyCode ?? 'GBP',
      currencySymbol: currencySymbol ?? '£',
      decimalPlaces: decimalPlaces ?? 5,
    );
  }

  Future<void> saveSettings(
    TradingSettings settings,
  ) async {
    await sharedPreferences.setString(
      _currencyCodeKey,
      settings.currencyCode,
    );

    await sharedPreferences.setString(
      _currencySymbolKey,
      settings.currencySymbol,
    );

    await sharedPreferences.setInt(
      _decimalPlacesKey,
      settings.decimalPlaces,
    );
  }
}

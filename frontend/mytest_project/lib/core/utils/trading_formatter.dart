
import 'package:mytest_project/features/settings/domain/entities/trading_settings.dart';

class TradingFormatter {
  const TradingFormatter._();

  /// Formats a trading price using the user's selected
  /// decimal precision.
  ///
  /// Example:
  /// 1.123456 with 5 decimal places → 1.12346
  static String formatPrice(
    double price,
    TradingSettings settings,flutter
  ) {
    return price.toStringAsFixed(
      settings.decimalPlaces,
    );
  }

  /// Formats profit/loss using the user's selected
  /// currency symbol and decimal precision.
  ///
  /// Example:
  /// £50.12345
  static String formatProfitLoss(
    double profitLoss,
    TradingSettings settings,
  ) {
    final sign = profitLoss >= 0 ? '+' : '';

    return '$sign${settings.currencySymbol}'
        '${profitLoss.toStringAsFixed(settings.decimalPlaces)}';
  }

  /// Formats a monetary value using the selected currency
  /// and decimal precision.
  ///
  /// Example:
  /// £1,250.12345
  static String formatMoney(
    double amount,
    TradingSettings settings,
  ) {
    final sign = amount >= 0 ? '+' : '';

    return '$sign${settings.currencySymbol}'
        '${amount.toStringAsFixed(settings.decimalPlaces)}';
  }
}


import 'package:mytest_project/features/auto_trading/domain/entities/auto_trading_settings.dart';

class AutoTradingSettingsModel extends AutoTradingSettings {
  const AutoTradingSettingsModel({
    required super.enabled,
    required super.minimumSignalQuality,
    required super.minimumAiConfidence,
    required super.allowBuy,
    required super.allowSell,
    required super.requireAiConfirmation,
    required super.requireStopLoss,
    required super.requireTakeProfit,
  });

  factory AutoTradingSettingsModel.fromJson(Map<String, dynamic> json) {
    return AutoTradingSettingsModel(
      enabled: json['auto_trading_enabled'] == true,

      minimumSignalQuality: _toDouble(json['minimum_signal_quality']),

      minimumAiConfidence: _toDouble(json['minimum_ai_confidence']),

      allowBuy: json['allow_buy'] == true,

      allowSell: json['allow_sell'] == true,

      requireAiConfirmation: json['require_ai_confirmation'] == true,

      requireStopLoss: json['require_stop_loss'] == true,

      requireTakeProfit: json['require_take_profit'] == true,
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}

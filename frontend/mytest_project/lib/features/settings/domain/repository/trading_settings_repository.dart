import 'package:mytest_project/features/settings/domain/entities/trading_settings.dart';

abstract interface class TradingSettingsRepository {
TradingSettings getSettings();

Future<void> saveSettings(
TradingSettings settings,
);
}

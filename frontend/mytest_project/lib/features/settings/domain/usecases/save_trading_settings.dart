import 'package:mytest_project/features/settings/domain/entities/trading_settings.dart';
import 'package:mytest_project/features/settings/domain/repository/trading_settings_repository.dart';

class SaveTradingSettings {
final TradingSettingsRepository repository;

SaveTradingSettings(
this.repository,
);

Future<void> call(
TradingSettings settings,
) async {
await repository.saveSettings(settings);
}
}

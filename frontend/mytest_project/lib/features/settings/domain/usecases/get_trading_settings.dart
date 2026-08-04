import 'package:mytest_project/features/settings/domain/entities/trading_settings.dart';
import 'package:mytest_project/features/settings/domain/repository/trading_settings_repository.dart';

class GetTradingSettings {
final TradingSettingsRepository repository;

GetTradingSettings(
this.repository,
);

TradingSettings call() {
return repository.getSettings();
}
}

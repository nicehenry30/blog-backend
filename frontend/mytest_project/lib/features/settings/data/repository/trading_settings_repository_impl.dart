import 'package:mytest_project/features/settings/data/datasources/trading_settings_local_data_source.dart';
import 'package:mytest_project/features/settings/domain/entities/trading_settings.dart';
import 'package:mytest_project/features/settings/domain/repository/trading_settings_repository.dart';

class TradingSettingsRepositoryImpl
implements TradingSettingsRepository {
final TradingSettingsLocalDataSource localDataSource;

TradingSettingsRepositoryImpl(
this.localDataSource,
);

@override
TradingSettings getSettings() {
return localDataSource.getSettings();
}

@override
Future<void> saveSettings(
TradingSettings settings,
) async {
await localDataSource.saveSettings(settings);
}
}

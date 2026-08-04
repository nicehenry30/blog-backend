import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mytest_project/features/settings/domain/entities/trading_settings.dart';
import 'package:mytest_project/features/settings/domain/usecases/get_trading_settings.dart';
import 'package:mytest_project/features/settings/domain/usecases/save_trading_settings.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
final GetTradingSettings getTradingSettings;
final SaveTradingSettings saveTradingSettings;

TradingSettings? _currentSettings;

SettingsBloc({
required this.getTradingSettings,
required this.saveTradingSettings,
}) : super(const SettingsInitial()) {
on<SettingsLoadRequested>(_onLoadRequested);
on<SettingsCurrencyChanged>(_onCurrencyChanged);
on<SettingsDecimalPlacesChanged>(_onDecimalPlacesChanged);
on<SettingsSaveRequested>(_onSaveRequested);
}

Future<void> _onLoadRequested(
SettingsLoadRequested event,
Emitter<SettingsState> emit,
) async {
emit(const SettingsLoading());


try {
  final settings = getTradingSettings();

  _currentSettings = settings;

  emit(
    SettingsLoaded(
      settings: settings,
    ),
  );
} catch (e) {
  emit(
    SettingsFailure(
      message: e.toString(),
    ),
  );
}

}

void _onCurrencyChanged(
SettingsCurrencyChanged event,
Emitter<SettingsState> emit,
) {
final currentSettings =
_currentSettings ?? const TradingSettings.defaultSettings();


final updatedSettings = currentSettings.copyWith(
  currencyCode: event.currencyCode,
  currencySymbol: event.currencySymbol,
);

_currentSettings = updatedSettings;

emit(
  SettingsLoaded(
    settings: updatedSettings,
  ),
);


}

void _onDecimalPlacesChanged(
SettingsDecimalPlacesChanged event,
Emitter<SettingsState> emit,
) {
final currentSettings =
_currentSettings ?? const TradingSettings.defaultSettings();


final updatedSettings = currentSettings.copyWith(
  decimalPlaces: event.decimalPlaces,
);

_currentSettings = updatedSettings;

emit(
  SettingsLoaded(
    settings: updatedSettings,
  ),
);

}

Future<void> _onSaveRequested(
SettingsSaveRequested event,
Emitter<SettingsState> emit,
) async {
final settings =
_currentSettings ?? const TradingSettings.defaultSettings();


emit(
  SettingsSaving(
    settings: settings,
  ),
);

try {
  await saveTradingSettings(settings);

  emit(
    SettingsSaved(
      settings: settings,
    ),
  );
} catch (e) {
  emit(
    SettingsFailure(
      message: e.toString(),
    ),
  );
}


}
}

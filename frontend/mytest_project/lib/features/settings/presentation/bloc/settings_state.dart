part of 'settings_bloc.dart';

sealed class SettingsState {
const SettingsState();
}

final class SettingsInitial extends SettingsState {
const SettingsInitial();
}

final class SettingsLoading extends SettingsState {
const SettingsLoading();
}

final class SettingsLoaded extends SettingsState {
final TradingSettings settings;

const SettingsLoaded({
required this.settings,
});
}

final class SettingsSaving extends SettingsState {
final TradingSettings settings;

const SettingsSaving({
required this.settings,
});
}

final class SettingsSaved extends SettingsState {
final TradingSettings settings;

const SettingsSaved({
required this.settings,
});
}

final class SettingsFailure extends SettingsState {
final String message;

const SettingsFailure({
required this.message,
});
}

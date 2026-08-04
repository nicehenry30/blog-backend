part of 'settings_bloc.dart';

sealed class SettingsEvent {
const SettingsEvent();
}

// Load the user's saved trading settings.
final class SettingsLoadRequested extends SettingsEvent {
const SettingsLoadRequested();
}

// Change the selected currency.
final class SettingsCurrencyChanged extends SettingsEvent {
final String currencyCode;
final String currencySymbol;

const SettingsCurrencyChanged({
required this.currencyCode,
required this.currencySymbol,
});
}

// Change the number of decimal places.
final class SettingsDecimalPlacesChanged extends SettingsEvent {
final int decimalPlaces;

const SettingsDecimalPlacesChanged({
required this.decimalPlaces,
});
}

// Save the current settings.
final class SettingsSaveRequested extends SettingsEvent {
const SettingsSaveRequested();
}

part of 'risk_settings_bloc.dart';

sealed class RiskSettingsState {}

final class RiskSettingsInitial extends RiskSettingsState {}

final class RiskSettingsLoading extends RiskSettingsState {}

final class RiskSettingsLoaded extends RiskSettingsState {
  final RiskSettings settings;

  RiskSettingsLoaded({
    required this.settings,
  });
}

final class RiskSettingsUpdating extends RiskSettingsState {
  final RiskSettings settings;

  RiskSettingsUpdating({
    required this.settings,
  });
}

final class RiskSettingsUpdated extends RiskSettingsState {
  final RiskSettings settings;

  RiskSettingsUpdated({
    required this.settings,
  });
}

final class RiskSettingsFailure extends RiskSettingsState {
  final String message;

  RiskSettingsFailure({
    required this.message,
  });
}
part of 'risk_settings_bloc.dart';

sealed class RiskSettingsEvent {}

final class RiskSettingsLoadRequested
    extends RiskSettingsEvent {}

final class RiskSettingsUpdateRequested
    extends RiskSettingsEvent {
  final double riskPerTrade;
  final double dailyLossLimit;
  final double maxDrawdown;

  RiskSettingsUpdateRequested({
    required this.riskPerTrade,
    required this.dailyLossLimit,
    required this.maxDrawdown,
  });
}
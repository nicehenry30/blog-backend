import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mytest_project/core/usecase/usecase.dart';
import 'package:mytest_project/features/risk_settings/domain/entities/risk_settings.dart';
import 'package:mytest_project/features/risk_settings/domain/usecases/get_risk_settings.dart';
import 'package:mytest_project/features/risk_settings/domain/usecases/update_risk_settings.dart';

part 'risk_settings_event.dart';
part 'risk_settings_state.dart';

class RiskSettingsBloc
    extends Bloc<RiskSettingsEvent, RiskSettingsState> {
  final GetRiskSettings getRiskSettings;
  final UpdateRiskSettings updateRiskSettings;

  RiskSettingsBloc({
    required this.getRiskSettings,
    required this.updateRiskSettings,
  }) : super(RiskSettingsInitial()) {
    on<RiskSettingsLoadRequested>(
      _onLoadRequested,
    );

    on<RiskSettingsUpdateRequested>(
      _onUpdateRequested,
    );
  }

  Future<void> _onLoadRequested(
    RiskSettingsLoadRequested event,
    Emitter<RiskSettingsState> emit,
  ) async {
    emit(RiskSettingsLoading());

    final result = await getRiskSettings(
      NoParams(),
    );

    result.fold(
      (failure) {
        emit(
          RiskSettingsFailure(
            message: failure.message,
          ),
        );
      },
      (settings) {
        emit(
          RiskSettingsLoaded(
            settings: settings,
          ),
        );
      },
    );
  }

  Future<void> _onUpdateRequested(
    RiskSettingsUpdateRequested event,
    Emitter<RiskSettingsState> emit,
  ) async {
    final settings = RiskSettings(
      riskPerTrade: event.riskPerTrade,
      dailyLossLimit: event.dailyLossLimit,
      maxDrawdown: event.maxDrawdown,
    );

    emit(
      RiskSettingsUpdating(
        settings: settings,
      ),
    );

    final result = await updateRiskSettings(
      settings,
    );

    result.fold(
      (failure) {
        emit(
          RiskSettingsFailure(
            message: failure.message,
          ),
        );
      },
      (updatedSettings) {
        emit(
          RiskSettingsUpdated(
            settings: updatedSettings,
          ),
        );
      },
    );
  }
}
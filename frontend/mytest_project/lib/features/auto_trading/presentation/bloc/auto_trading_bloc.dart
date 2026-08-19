import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mytest_project/features/auto_trading/domain/entities/auto_trading_settings.dart';
import 'package:mytest_project/features/auto_trading/domain/usecases/get_auto_trading_status.dart';
import 'package:mytest_project/features/auto_trading/domain/usecases/update_auto_trading.dart';
import 'package:mytest_project/features/auto_trading/domain/usecases/update_auto_trading_preferences.dart';

part 'auto_trading_event.dart';
part 'auto_trading_state.dart';

class AutoTradingBloc
    extends Bloc<AutoTradingEvent, AutoTradingState> {
  final GetAutoTradingStatus getAutoTradingStatus;
  final UpdateAutoTrading updateAutoTrading;
  final UpdateAutoTradingPreferences updateAutoTradingPreferences;

  AutoTradingBloc({
    required this.getAutoTradingStatus,
    required this.updateAutoTrading,
    required this.updateAutoTradingPreferences,
  }) : super(const AutoTradingInitial()) {
    on<AutoTradingLoadRequested>(_onLoadRequested);
    on<AutoTradingChanged>(_onAutoTradingChanged);
    on<AutoTradingPreferencesChanged>(
      _onPreferencesChanged,
    );
  }

  Future<void> _onLoadRequested(
    AutoTradingLoadRequested event,
    Emitter<AutoTradingState> emit,
  ) async {
    emit(const AutoTradingLoading());

    final result = await getAutoTradingStatus();

    result.match(
      (failure) => emit(
        AutoTradingFailure(failure.message),
      ),
      (settings) => emit(
        AutoTradingLoaded(settings),
      ),
    );
  }

  Future<void> _onAutoTradingChanged(
    AutoTradingChanged event,
    Emitter<AutoTradingState> emit,
  ) async {
    final previousSettings =
        state is AutoTradingLoaded
            ? (state as AutoTradingLoaded).settings
            : null;

    if (previousSettings == null) {
      return;
    }

    emit(
      AutoTradingUpdating(
        settings: AutoTradingSettings(
          enabled: event.enabled,
          minimumSignalQuality:
              previousSettings.minimumSignalQuality,
          minimumAiConfidence:
              previousSettings.minimumAiConfidence,
          allowBuy: previousSettings.allowBuy,
          allowSell: previousSettings.allowSell,
          requireAiConfirmation:
              previousSettings.requireAiConfirmation,
          requireStopLoss:
              previousSettings.requireStopLoss,
          requireTakeProfit:
              previousSettings.requireTakeProfit,
        ),
      ),
    );

    final result = await updateAutoTrading(event.enabled);

    result.match(
      (failure) => emit(
        AutoTradingFailure(
          failure.message,
          previousSettings: previousSettings,
        ),
      ),
      (settings) => emit(
        AutoTradingLoaded(settings),
      ),
    );
  }

  Future<void> _onPreferencesChanged(
    AutoTradingPreferencesChanged event,
    Emitter<AutoTradingState> emit,
  ) async {
    final previousSettings =
        state is AutoTradingLoaded
            ? (state as AutoTradingLoaded).settings
            : null;

    if (previousSettings == null) {
      return;
    }

    final optimisticSettings = AutoTradingSettings(
      enabled: previousSettings.enabled,
      minimumSignalQuality:
          event.minimumSignalQuality ??
              previousSettings.minimumSignalQuality,
      minimumAiConfidence:
          event.minimumAiConfidence ??
              previousSettings.minimumAiConfidence,
      allowBuy:
          event.allowBuy ?? previousSettings.allowBuy,
      allowSell:
          event.allowSell ?? previousSettings.allowSell,
      requireAiConfirmation:
          event.requireAiConfirmation ??
              previousSettings.requireAiConfirmation,
      requireStopLoss:
          event.requireStopLoss ??
              previousSettings.requireStopLoss,
      requireTakeProfit:
          event.requireTakeProfit ??
              previousSettings.requireTakeProfit,
    );

    emit(
      AutoTradingUpdating(
        settings: optimisticSettings,
      ),
    );

    final result = await updateAutoTradingPreferences(
      minimumSignalQuality:
          event.minimumSignalQuality,
      minimumAiConfidence:
          event.minimumAiConfidence,
      allowBuy: event.allowBuy,
      allowSell: event.allowSell,
      requireAiConfirmation:
          event.requireAiConfirmation,
      requireStopLoss: event.requireStopLoss,
      requireTakeProfit:
          event.requireTakeProfit,
    );

    result.match(
      (failure) => emit(
        AutoTradingFailure(
          failure.message,
          previousSettings: previousSettings,
        ),
      ),
      (settings) => emit(
        AutoTradingLoaded(settings),
      ),
    );
  }
}
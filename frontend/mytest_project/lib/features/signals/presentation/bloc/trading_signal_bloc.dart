import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';

import '../../domain/entities/ai_signal_confirmation.dart';
import '../../domain/entities/trading_signal.dart';
import '../../domain/usecases/get_ai_signal_confirmation.dart';
import '../../domain/usecases/get_trading_signal_details.dart';
import '../../domain/usecases/get_trading_signals.dart';


part 'trading_signal_event.dart';
part 'trading_signal_state.dart';

class TradingSignalBloc
    extends Bloc<TradingSignalEvent, TradingSignalState> {
  final GetTradingSignals getTradingSignals;
  final GetTradingSignalDetails getTradingSignalDetails;
  final GetAiSignalConfirmation getAiConfirmation;

  TradingSignalBloc({
    required this.getTradingSignals,
    required this.getTradingSignalDetails,
    required this.getAiConfirmation,
  }) : super(TradingSignalInitial()) {
    on<LoadTradingSignals>(_onLoadTradingSignals);
    on<LoadTradingSignalDetails>(_onLoadTradingSignalDetails);
    on<LoadAiSignalConfirmation>(_onLoadAiSignalConfirmation);
  }

  Future<void> _onLoadTradingSignals(
    LoadTradingSignals event,
    Emitter<TradingSignalState> emit,
  ) async {
    emit(TradingSignalLoading());

    final result = await getTradingSignals(NoParams());

    result.fold(
      (failure) => emit(
        TradingSignalFailure(failure.message),
      ),
      (signals) => emit(
        TradingSignalLoaded(signals),
      ),
    );
  }

  Future<void> _onLoadTradingSignalDetails(
    LoadTradingSignalDetails event,
    Emitter<TradingSignalState> emit,
  ) async {
    emit(TradingSignalLoading());

    final result = await getTradingSignalDetails(
      event.signalId,
    );

    result.fold(
      (failure) => emit(
        TradingSignalFailure(failure.message),
      ),
      (signal) => emit(
        TradingSignalDetailsLoaded(signal),
      ),
    );
  }

  Future<void> _onLoadAiSignalConfirmation(
    LoadAiSignalConfirmation event,
    Emitter<TradingSignalState> emit,
  ) async {
    emit(AiSignalConfirmationLoading());

    final result = await getAiConfirmation(
      event.signalId,
    );

    result.fold(
      (failure) => emit(
        AiSignalConfirmationFailure(failure.message),
      ),
      (confirmation) => emit(
        AiSignalConfirmationLoaded(confirmation),
      ),
    );
  }
}
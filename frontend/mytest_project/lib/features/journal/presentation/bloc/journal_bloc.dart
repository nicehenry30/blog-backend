import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mytest_project/core/usecase/usecase.dart';
import 'package:mytest_project/features/journal/domain/entities/trade.dart';
import 'package:mytest_project/features/journal/domain/usecases/add_trade.dart';
import 'package:mytest_project/features/journal/domain/usecases/delete_trade.dart';
import 'package:mytest_project/features/journal/domain/usecases/get_trades.dart';
import 'package:mytest_project/features/journal/domain/usecases/update_trade.dart';

part 'journal_event.dart';
part 'journal_state.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  final GetTrades getTrades;
  final AddTrade addTrade;
  final UpdateTrade updateTrade;
  final DeleteTrade deleteTrade;

  JournalBloc({
    required this.getTrades,
    required this.addTrade,
    required this.updateTrade,
    required this.deleteTrade,
  }) : super(const JournalInitial()) {
    on<JournalLoadTrades>(_onLoadTrades);
    on<JournalAddTrade>(_onAddTrade);
    on<JournalUpdateTrade>(_onUpdateTrade);
    on<JournalDeleteTrade>(_onDeleteTrade);
  }

  Future<void> _onLoadTrades(
    JournalLoadTrades event,
    Emitter<JournalState> emit,
  ) async {
    emit(const JournalLoading());

    final result = await getTrades(NoParams());

    result.fold(
      (failure) {
        emit(JournalFailure(failure.message));
      },
      (trades) {
        emit(JournalLoaded(trades));
      },
    );
  }

  Future<void> _onAddTrade(
    JournalAddTrade event,
    Emitter<JournalState> emit,
  ) async {
    final result = await addTrade(event.trade);

    result.fold(
      (failure) {
        emit(JournalFailure(failure.message));
      },
      (_) {
        add(const JournalLoadTrades());
      },
    );
  }

  Future<void> _onUpdateTrade(
    JournalUpdateTrade event,
    Emitter<JournalState> emit,
  ) async {
    emit(const JournalLoading());

    final result = await updateTrade(event.trade);

    result.fold(
      (failure) {
        emit(JournalFailure(failure.message));
      },
      (_) {
        add(const JournalLoadTrades());
      },
    );
  }

  Future<void> _onDeleteTrade(
    JournalDeleteTrade event,
    Emitter<JournalState> emit,
  ) async {
    emit(const JournalLoading());

    final result = await deleteTrade(event.tradeId);

    result.fold(
      (failure) {
        emit(JournalFailure(failure.message));
      },
      (_) {
        add(const JournalLoadTrades());
      },
    );
  }
}
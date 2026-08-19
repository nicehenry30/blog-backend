import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mytest_project/features/market_alerts/domain/usecases/get_market_alerts.dart';
import 'market_alert_event.dart';
import 'market_alert_state.dart';

class MarketAlertBloc
    extends Bloc<MarketAlertEvent, MarketAlertState> {
  final GetMarketAlerts getMarketAlerts;

  MarketAlertBloc({
    required this.getMarketAlerts,
  }) : super(MarketAlertInitial()) {
    on<LoadMarketAlerts>(_onLoadMarketAlerts);
  }

  Future<void> _onLoadMarketAlerts(
    LoadMarketAlerts event,
    Emitter<MarketAlertState> emit,
  ) async {
    emit(MarketAlertLoading());

    final result = await getMarketAlerts();

    result.fold(
      (failure) {
        emit(
          MarketAlertFailure(
            failure.message,
          ),
        );
      },
      (alerts) {
        emit(
          MarketAlertLoaded(
            alerts,
          ),
        );
      },
    );
  }
}
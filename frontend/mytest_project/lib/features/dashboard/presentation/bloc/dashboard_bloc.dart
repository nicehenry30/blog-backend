import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mytest_project/core/usecase/usecase.dart';
import 'package:mytest_project/features/dashboard/domain/entities/dashboard.dart';
import 'package:mytest_project/features/dashboard/domain/usecases/get_dashboard.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc
    extends Bloc<DashboardEvent, DashboardState> {

  final GetDashboard getDashboard;

  DashboardBloc({
  required this.getDashboard,
}) : super(DashboardInitial()) {

    on<DashboardLoadRequested>(
      _onDashboardLoadRequested,
    );
  }


  Future<void> _onDashboardLoadRequested(
    DashboardLoadRequested event,
    Emitter<DashboardState> emit,
  ) async {

    emit(DashboardLoading());

    final result = await getDashboard(
  NoParams(),
  );

    result.fold(
      (failure) {
        emit(
          DashboardFailure(
            message: failure.message,
          ),
        );
      },
      (dashboard) {
        emit(
          DashboardLoaded(
            dashboard: dashboard,
          ),
        );
      },
    );
  }
}
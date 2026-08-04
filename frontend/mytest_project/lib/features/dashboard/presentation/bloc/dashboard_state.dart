part of 'dashboard_bloc.dart';

sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

final class DashboardLoading extends DashboardState {}

final class DashboardLoaded extends DashboardState {
  final Dashboard dashboard;

  DashboardLoaded({
    required this.dashboard,
  });
}

final class DashboardFailure extends DashboardState {
  final String message;

  DashboardFailure({
    required this.message,
  });
}
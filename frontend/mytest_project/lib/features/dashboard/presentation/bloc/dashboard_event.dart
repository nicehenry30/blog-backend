part of 'dashboard_bloc.dart';

sealed class DashboardEvent {}

class DashboardLoadRequested extends DashboardEvent {}
part of 'guardian_bloc.dart';

sealed class GuardianEvent {}

final class GuardianLoadRequested extends GuardianEvent {
  final String platform;

  GuardianLoadRequested({
    required this.platform,
  });
}

final class GuardianConnectionCodeRequested
    extends GuardianEvent {
  final String platform;

  GuardianConnectionCodeRequested({
    required this.platform,
  });
}

final class GuardianDisconnectRequested
    extends GuardianEvent {
  final String platform;

  GuardianDisconnectRequested({
    required this.platform,
  });
}
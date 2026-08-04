part of 'guardian_bloc.dart';

sealed class GuardianEvent {}

final class GuardianLoadRequested
    extends GuardianEvent {}

final class GuardianConnectionCodeRequested
    extends GuardianEvent {
  final String platform;

  GuardianConnectionCodeRequested({
    required this.platform,
  });
}

final class GuardianDisconnectRequested
    extends GuardianEvent {}
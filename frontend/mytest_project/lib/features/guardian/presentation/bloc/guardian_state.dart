part of 'guardian_bloc.dart';

sealed class GuardianState {}

final class GuardianInitial extends GuardianState {}

final class GuardianLoading extends GuardianState {}

final class GuardianLoaded extends GuardianState {
  final GuardianAccount account;

  GuardianLoaded({
    required this.account,
  });
}

final class GuardianConnectionCodeLoading
    extends GuardianState {}

final class GuardianConnectionCodeGenerated
    extends GuardianState {
  final String code;
  final String platform;

  GuardianConnectionCodeGenerated({
    required this.code,
    required this.platform,
  });
}

final class GuardianFailure extends GuardianState {
  final String message;

  GuardianFailure({
    required this.message,
  });  
}

final class GuardianDisconnecting
    extends GuardianState {}

final class GuardianDisconnected
    extends GuardianState {}
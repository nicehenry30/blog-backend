part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final Profile profile;

  ProfileLoaded(this.profile);
}

final class ProfileUpdating extends ProfileState {}

final class ProfileUpdated extends ProfileState {
  final Profile profile;

  ProfileUpdated(this.profile);
}

final class ProfileFailure extends ProfileState {
  final String message;

  ProfileFailure(this.message);
}
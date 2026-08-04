part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final Profile profile;

  UpdateProfileEvent(this.profile);
}
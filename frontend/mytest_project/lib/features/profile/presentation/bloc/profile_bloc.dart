import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';

import '../../domain/entities/profile.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfile getProfile;
  final UpdateProfile updateProfile;

  ProfileBloc({
    required this.getProfile,
    required this.updateProfile,
  }) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    final result = await getProfile(NoParams());

    result.fold(
      (failure) => emit(
        ProfileFailure(failure.message),
      ),
      (profile) => emit(
        ProfileLoaded(profile),
      ),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileUpdating());

    final result = await updateProfile(event.profile);

    result.fold(
      (failure) => emit(
        ProfileFailure(failure.message),
      ),
      (_) => emit(
        ProfileUpdated(),
      ),
    );
  }
}
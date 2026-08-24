import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

import '../entities/profile.dart';
import '../repository/profile_repository.dart';

class UpdateProfile implements UseCase<Profile, Profile> {
  final ProfileRepository repository;

  UpdateProfile(
    this.repository,
  );

  @override
  Future<Either<Failure, Profile>> call(
    Profile params,
  ) {
    return repository.updateProfile(params);
  }
}
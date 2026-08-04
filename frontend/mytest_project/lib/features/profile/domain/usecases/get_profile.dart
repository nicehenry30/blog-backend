import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

import '../entities/profile.dart';
import '../repository/profile_repository.dart';

class GetProfile
    implements UseCase<Profile, NoParams> {
  final ProfileRepository repository;

  GetProfile(
    this.repository,
  );

  @override
  Future<Either<Failure, Profile>> call(
    NoParams params,
  ) {
    return repository.getProfile();
  }
}
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/profile.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile();

  Future<Either<Failure, void>> updateProfile(
    Profile profile,
  );
}
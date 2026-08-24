import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';

import '../../domain/entities/profile.dart';
import '../../domain/repository/profile_repository.dart';

import '../datasources/profile_remote_data_source.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl
    implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, Profile>> getProfile() async {
    try {
      final profile =
          await remoteDataSource.getProfile();

      return Right(profile);
    } catch (e) {
      return Left(
        Failure(
          'Failed to load profile: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Profile>> updateProfile(
    Profile profile,
  ) async {
    try {
      final profileModel = ProfileModel(
        id: profile.id,
        name: profile.name,
        email: profile.email,
        subscription: profile.subscription,
        mt4Connected: profile.mt4Connected,
        mt5Connected: profile.mt5Connected,
      );

      final updatedProfile =
          await remoteDataSource.updateProfile(
        profileModel,
      );

      return Right(updatedProfile);
    } catch (e) {
      return Left(
        Failure(
          'Failed to update profile: ${e.toString()}',
        ),
      );
    }
  }
}
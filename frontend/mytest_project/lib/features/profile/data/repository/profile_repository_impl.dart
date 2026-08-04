import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';

import '../../domain/entities/profile.dart';
import '../../domain/repository/profile_repository.dart';

import '../datasources/profile_remote_data_source.dart';

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
        const Failure(
          'Failed to load profile.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(
    Profile profile,
  ) async {
    try {
      await remoteDataSource.updateProfile(profile as dynamic);

      return const Right(null);
    } catch (e) {
      return Left(
        const Failure(
          'Failed to update profile.',
        ),
      );
    }
  }
}
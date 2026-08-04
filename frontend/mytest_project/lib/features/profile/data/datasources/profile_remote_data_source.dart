import '../models/profile_model.dart';

abstract interface class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();

  Future<void> updateProfile(
    ProfileModel profile,
  );
}

class ProfileRemoteDataSourceImpl
    implements ProfileRemoteDataSource {
  @override
  Future<ProfileModel> getProfile() async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateProfile(
    ProfileModel profile,
  ) async {
    throw UnimplementedError();
  }
}
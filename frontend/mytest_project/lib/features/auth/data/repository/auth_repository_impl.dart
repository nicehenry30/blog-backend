import 'package:fpdart/fpdart.dart';
import 'package:mytest_project/core/error/exceptions.dart';
import 'package:mytest_project/core/error/failures.dart';
import 'package:mytest_project/core/storage/local_storage.dart';
import 'package:mytest_project/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mytest_project/features/auth/domain/entities/auth_user.dart';
import 'package:mytest_project/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final LocalStorage localStorage;

  AuthRepositoryImpl(
    this.authRemoteDataSource,
    this.localStorage,
  );

  @override
  Future<Either<Failure, AuthUser>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final user = await authRemoteDataSource.signUpWithEmailPassword(
        email: email,
        password: password,
        name: name,
      );

      await localStorage.saveToken(user.token);

      print('SIGNUP TOKEN SAVED: ${user.token}');

      return Right(user);
    } on ServerException catch (e) {
      print('SIGNUP SERVER ERROR: ${e.message}');
      return Left(Failure(e.message));
    } catch (e) {
      print('SIGNUP ERROR: $e');
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await authRemoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      );

      await localStorage.saveToken(user.token);

      print('LOGIN TOKEN SAVED: ${user.token}');

      return Right(user);
    } on ServerException catch (e) {
      print('LOGIN SERVER ERROR: ${e.message}');
      return Left(Failure(e.message));
    } catch (e) {
      print('LOGIN ERROR: $e');
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> getCurrentUser() async {
    try {
      final token = localStorage.getToken();

      print('SAVED TOKEN: $token');

      if (token == null || token.isEmpty) {
        print('NO TOKEN FOUND');

        return Left(
          Failure('No authentication token found'),
        );
      }

      print('CALLING GET CURRENT USER');

      final user = await authRemoteDataSource.getCurrentUser(
        token: token,
      );

      print('CURRENT USER FOUND: ${user.name}');
      print('CURRENT USER EMAIL: ${user.email}');

      return Right(user);
    } on ServerException catch (e) {
      print('CURRENT USER SERVER ERROR: ${e.message}');

      await localStorage.removeToken();

      return Left(
        Failure(e.message),
      );
    } catch (e) {
      print('CURRENT USER ERROR: $e');

      return Left(
        Failure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final token = localStorage.getToken();

      print('LOGOUT TOKEN: $token');

      if (token != null && token.isNotEmpty) {
        await authRemoteDataSource.logout(
          token: token,
        );
      }

      await localStorage.removeToken();

      print('TOKEN REMOVED');

      return const Right(null);
    } on ServerException catch (e) {
      print('LOGOUT SERVER ERROR: ${e.message}');

      return Left(
        Failure(e.message),
      );
    } catch (e) {
      print('LOGOUT ERROR: $e');

      return Left(
        Failure(e.toString()),
      );
    }
  }
}
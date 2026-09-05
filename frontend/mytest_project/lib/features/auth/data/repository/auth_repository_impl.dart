import 'dart:developer' as developer;

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
    String? referralCode,
  }) async {
    try {
      final user =
          await authRemoteDataSource.signUpWithEmailPassword(
        email: email,
        password: password,
        name: name,
        referralCode: referralCode,
      );

      await localStorage.saveToken(user.token);

      developer.log(
        'SIGNUP TOKEN SAVED: ${user.token}',
      );

      return Right(user);
    } on ServerException catch (e) {
      developer.log(
        'SIGNUP SERVER ERROR: ${e.message}',
      );

      return Left(
        Failure(e.message),
      );
    } catch (e) {
      developer.log(
        'SIGNUP ERROR: $e',
      );

      return Left(
        Failure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, AuthUser>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user =
          await authRemoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      );

      await localStorage.saveToken(user.token);

      developer.log(
        'LOGIN TOKEN SAVED: ${user.token}',
      );

      return Right(user);
    } on ServerException catch (e) {
      developer.log(
        'LOGIN SERVER ERROR: ${e.message}',
      );

      return Left(
        Failure(e.message),
      );
    } catch (e) {
      developer.log(
        'LOGIN ERROR: $e',
      );

      return Left(
        Failure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, AuthUser>> getCurrentUser() async {
    try {
      final token = localStorage.getToken();

      developer.log(
        'SAVED TOKEN: $token',
      );

      if (token == null || token.isEmpty) {
        developer.log(
          'NO TOKEN FOUND',
        );

        return Left(
          Failure(
            'No authentication token found',
          ),
        );
      }

      developer.log(
        'CALLING GET CURRENT USER',
      );

      final user =
          await authRemoteDataSource.getCurrentUser(
        token: token,
      );

      developer.log(
        'CURRENT USER FOUND: ${user.name}',
      );

      developer.log(
        'CURRENT USER EMAIL: ${user.email}',
      );

      return Right(user);
    } on ServerException catch (e) {
      developer.log(
        'CURRENT USER SERVER ERROR: ${e.message}',
      );

      await localStorage.removeToken();

      return Left(
        Failure(e.message),
      );
    } catch (e) {
      developer.log(
        'CURRENT USER ERROR: $e',
      );

      return Left(
        Failure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final token = localStorage.getToken();

      developer.log(
        'LOGOUT TOKEN: $token',
      );

      if (token != null && token.isNotEmpty) {
        await authRemoteDataSource.logout(
          token: token,
        );
      }

      await localStorage.removeToken();

      developer.log(
        'TOKEN REMOVED',
      );

      return const Right(null);
    } on ServerException catch (e) {
      developer.log(
        'LOGOUT SERVER ERROR: ${e.message}',
      );

      return Left(
        Failure(e.message),
      );
    } catch (e) {
      developer.log(
        'LOGOUT ERROR: $e',
      );

      return Left(
        Failure(e.toString()),
      );
    }
  }
}
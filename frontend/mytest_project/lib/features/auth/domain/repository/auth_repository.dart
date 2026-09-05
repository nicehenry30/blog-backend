import 'package:fpdart/fpdart.dart';
import 'package:mytest_project/core/error/failures.dart';
import 'package:mytest_project/features/auth/domain/entities/auth_user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, AuthUser>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
    String? referralCode,
  });

  Future<Either<Failure, AuthUser>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthUser>> getCurrentUser();

  Future<Either<Failure, void>> logout();
}
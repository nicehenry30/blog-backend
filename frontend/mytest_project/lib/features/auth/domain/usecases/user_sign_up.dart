// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:fpdart/fpdart.dart';

import 'package:mytest_project/core/error/failures.dart';
import 'package:mytest_project/core/usecase/usecase.dart';
import 'package:mytest_project/features/auth/domain/entities/auth_user.dart';
import 'package:mytest_project/features/auth/domain/repository/auth_repository.dart';

class UserSignUp implements UseCase<AuthUser, UserSignUpParams> {
  final AuthRepository authRepository;

  const UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, AuthUser>> call(
    UserSignUpParams params,
  ) async {
    return authRepository.signUpWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
      referralCode: params.referralCode,
    );
  }
}

class UserSignUpParams {
  final String email;
  final String password;
  final String name;
  final String? referralCode;

  const UserSignUpParams({
    required this.email,
    required this.password,
    required this.name,
    this.referralCode,
  });
}
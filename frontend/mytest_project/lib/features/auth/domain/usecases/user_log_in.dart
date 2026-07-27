// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:fpdart/fpdart.dart';
import 'package:mytest_project/core/error/failures.dart';
import 'package:mytest_project/core/usecase/usecase.dart';
import 'package:mytest_project/features/auth/domain/entities/auth_user.dart';
import 'package:mytest_project/features/auth/domain/repository/auth_repository.dart';

class UserLogIn implements UseCase<AuthUser, UserLogInParams> {
  final AuthRepository authRepository;

  const UserLogIn(this.authRepository);

  @override
  Future<Either<Failure, AuthUser>> call(UserLogInParams params) async {
    return authRepository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLogInParams {
  final String email;
  final String password;

  const UserLogInParams({required this.email, required this.password});
}

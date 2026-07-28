import 'package:fpdart/fpdart.dart';
import 'package:mytest_project/core/error/failures.dart';
import 'package:mytest_project/features/auth/domain/entities/auth_user.dart';
import 'package:mytest_project/features/auth/domain/repository/auth_repository.dart';

class UserGetCurrentUser {
  final AuthRepository authRepository;

  const UserGetCurrentUser(this.authRepository);

  Future<Either<Failure, AuthUser>> call() async {
    return authRepository.getCurrentUser();
  }
}
import 'package:fpdart/fpdart.dart';
import 'package:mytest_project/core/error/failures.dart';
import 'package:mytest_project/features/auth/domain/repository/auth_repository.dart';

class UserLogOut {
  final AuthRepository authRepository;

  const UserLogOut(this.authRepository);

  Future<Either<Failure, void>> call() async {
    return authRepository.logout();
  }
}
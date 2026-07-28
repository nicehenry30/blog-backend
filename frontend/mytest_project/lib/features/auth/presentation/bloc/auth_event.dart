part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class AuthSignUp extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const AuthSignUp({
    required this.name,
    required this.email,
    required this.password,
  });
}

class AuthLogIn extends AuthEvent {
  final String email;
  final String password;

  const AuthLogIn({
    required this.email,
    required this.password,
  });
}

class AuthLogOut extends AuthEvent {
  const AuthLogOut();
}
class AuthCheckStatus extends AuthEvent {
  const AuthCheckStatus();
}
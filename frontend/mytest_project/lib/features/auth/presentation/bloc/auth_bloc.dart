import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mytest_project/features/auth/domain/entities/auth_user.dart';
import 'package:mytest_project/features/auth/domain/usecases/user_get_current_user.dart';
import 'package:mytest_project/features/auth/domain/usecases/user_log_in.dart';
import 'package:mytest_project/features/auth/domain/usecases/user_log_out.dart';
import 'package:mytest_project/features/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogIn _userLogIn;
  final UserLogOut _userLogOut;
  final UserGetCurrentUser _userGetCurrentUser;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogIn userLogIn,
    required UserLogOut userLogOut,
    required UserGetCurrentUser userGetCurrentUser,
  })  : _userSignUp = userSignUp,
        _userLogIn = userLogIn,
        _userLogOut = userLogOut,
        _userGetCurrentUser = userGetCurrentUser,
        super(const AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogIn>(_onAuthLogIn);
    on<AuthLogOut>(_onAuthLogOut);
    on<AuthCheckStatus>(_onAuthCheckStatus);
  }

  Future<void> _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _userSignUp(
      UserSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
        referralCode: event.referralCode,
      ),
    );

    result.fold(
      (failure) {
        emit(AuthFailure(failure.message));
      },
      (user) {
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _onAuthLogIn(
    AuthLogIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _userLogIn(
      UserLogInParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) {
        emit(AuthFailure(failure.message));
      },
      (user) {
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _onAuthLogOut(
    AuthLogOut event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _userLogOut();

    result.fold(
      (failure) {
        emit(AuthFailure(failure.message));
      },
      (_) {
        emit(const AuthUnauthenticated());
      },
    );
  }

  Future<void> _onAuthCheckStatus(
    AuthCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _userGetCurrentUser();

    result.fold(
      (failure) {
        emit(const AuthUnauthenticated());
      },
      (user) {
        emit(AuthAuthenticated(user));
      },
    );
  }
}
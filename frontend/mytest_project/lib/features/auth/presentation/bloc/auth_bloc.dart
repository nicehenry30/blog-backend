import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mytest_project/features/auth/domain/usecases/user_log_in.dart';
import 'package:mytest_project/features/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogIn _userLogIn;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogIn userLogIn,
  })  : _userSignUp = userSignUp,
        _userLogIn = userLogIn,
        super(const AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogIn>(_onAuthLogIn);
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
      ),
    );

    result.fold(
      (failure) {
        emit(AuthFailure(failure.message));
      },
      (user) {
        emit(AuthSuccess(user));
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
        emit(AuthSuccess(user));
      },
    );
  }
}
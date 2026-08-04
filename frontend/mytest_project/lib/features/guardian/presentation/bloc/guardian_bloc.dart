import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mytest_project/core/usecase/usecase.dart';

import 'package:mytest_project/features/guardian/domain/entities/guardian_account.dart';
import 'package:mytest_project/features/guardian/domain/usecases/disconnect_guardian.dart';
import 'package:mytest_project/features/guardian/domain/usecases/generate_guardian_connection_code.dart';
import 'package:mytest_project/features/guardian/domain/usecases/get_guardian_account.dart';

part 'guardian_event.dart';
part 'guardian_state.dart';

class GuardianBloc
    extends Bloc<GuardianEvent, GuardianState> {
  final GetGuardianAccount getGuardianAccount;

  final GenerateGuardianConnectionCode
      generateGuardianConnectionCode;

  final DisconnectGuardian disconnectGuardian;

  GuardianBloc({
    required this.getGuardianAccount,
    required this.generateGuardianConnectionCode,
    required this.disconnectGuardian,
  }) : super(GuardianInitial()) {
    on<GuardianLoadRequested>(
      _onLoadRequested,
    );

    on<GuardianConnectionCodeRequested>(
      _onConnectionCodeRequested,
    );

    on<GuardianDisconnectRequested>(
      _onDisconnectRequested,
    );
  }

  Future<void> _onLoadRequested(
    GuardianLoadRequested event,
    Emitter<GuardianState> emit,
  ) async {
    emit(
      GuardianLoading(),
    );

    final result = await getGuardianAccount(
      NoParams(),
    );

    result.fold(
      (failure) {
        emit(
          GuardianFailure(
            message: failure.message,
          ),
        );
      },
      (account) {
        emit(
          GuardianLoaded(
            account: account,
          ),
        );
      },
    );
  }

  Future<void> _onConnectionCodeRequested(
    GuardianConnectionCodeRequested event,
    Emitter<GuardianState> emit,
  ) async {
    emit(
      GuardianConnectionCodeLoading(),
    );

    final result =
        await generateGuardianConnectionCode(
      event.platform,
    );

    result.fold(
      (failure) {
        emit(
          GuardianFailure(
            message: failure.message,
          ),
        );
      },
      (code) {
        emit(
          GuardianConnectionCodeGenerated(
            code: code,
            platform: event.platform,
          ),
        );
      },
    );
  }

  Future<void> _onDisconnectRequested(
    GuardianDisconnectRequested event,
    Emitter<GuardianState> emit,
  ) async {
    emit(
      GuardianDisconnecting(),
    );

    final result = await disconnectGuardian(
      NoParams(),
    );

    await result.fold(
      (failure) async {
        emit(
          GuardianFailure(
            message: failure.message,
          ),
        );
      },
      (_) async {
        emit(
          GuardianDisconnected(),
        );

        // Reload the Guardian account so the UI
        // immediately changes to "Not Connected".
        final reloadResult =
            await getGuardianAccount(
          NoParams(),
        );

        reloadResult.fold(
          (failure) {
            emit(
              GuardianFailure(
                message: failure.message,
              ),
            );
          },
          (account) {
            emit(
              GuardianLoaded(
                account: account,
              ),
            );
          },
        );
      },
    );
  }
}
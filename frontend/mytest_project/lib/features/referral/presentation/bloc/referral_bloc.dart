import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_referral_summary.dart';
import '../../domain/usecases/get_referrals.dart';
import '../../domain/entities/referral.dart';

import 'referral_event.dart';
import 'referral_state.dart';

class ReferralBloc
    extends Bloc<ReferralEvent, ReferralState> {
  final GetReferralSummary getReferralSummary;
  final GetReferrals getReferrals;

  ReferralBloc({
    required this.getReferralSummary,
    required this.getReferrals,
  }) : super(const ReferralInitial()) {
    on<ReferralLoadRequested>(
      _onLoadRequested,
    );
  }

  Future<void> _onLoadRequested(
    ReferralLoadRequested event,
    Emitter<ReferralState> emit,
  ) async {
    emit(const ReferralLoading());

    final summaryResult =
        await getReferralSummary();

    final referralsResult =
        await getReferrals();

    if (summaryResult.isLeft()) {
      emit(
        ReferralFailure(
          summaryResult.fold(
            (failure) => failure.message,
            (_) => 'Failed to load referral summary.',
          ),
        ),
      );

      return;
    }

    if (referralsResult.isLeft()) {
      emit(
        ReferralFailure(
          referralsResult.fold(
            (failure) => failure.message,
            (_) => 'Failed to load referrals.',
          ),
        ),
      );

      return;
    }

    final summary = summaryResult.getOrElse(
      (_) => throw StateError('Missing summary'),
    );

    final referrals = referralsResult.getOrElse(
    (_) => <Referral>[],
    );

    emit(
      ReferralLoaded(
        summary: summary,
        referrals: referrals,
      ),
    );
  }
}
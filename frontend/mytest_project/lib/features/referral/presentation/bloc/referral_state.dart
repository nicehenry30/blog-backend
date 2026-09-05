import '../../domain/entities/referral.dart';
import '../../domain/entities/referral_summary.dart';

abstract class ReferralState {
  const ReferralState();
}

class ReferralInitial extends ReferralState {
  const ReferralInitial();
}

class ReferralLoading extends ReferralState {
  const ReferralLoading();
}

class ReferralLoaded extends ReferralState {
  final ReferralSummary summary;
  final List<Referral> referrals;

  const ReferralLoaded({
    required this.summary,
    required this.referrals,
  });
}

class ReferralFailure extends ReferralState {
  final String message;

  const ReferralFailure(this.message);
}
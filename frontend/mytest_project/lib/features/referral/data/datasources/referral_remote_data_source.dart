import '../models/referral_model.dart';
import '../models/referral_summary_model.dart';

abstract interface class ReferralRemoteDataSource {
  Future<ReferralSummaryModel> getReferralSummary();

  Future<List<ReferralModel>> getReferrals();
}
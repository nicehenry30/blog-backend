import '../../domain/entities/referral_summary.dart';

class ReferralSummaryModel extends ReferralSummary {
  const ReferralSummaryModel({
    required super.referralCode,
    required super.totalReferrals,
    required super.pending,
    required super.qualified,
    required super.rewarded,
    required super.totalRewards,
    required super.rewardCurrency,
  });

  factory ReferralSummaryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ReferralSummaryModel(
      referralCode:
          json['referral_code']?.toString() ?? '',

      totalReferrals:
          (json['total_referrals'] as num?)?.toInt() ?? 0,

      pending:
          (json['pending'] as num?)?.toInt() ?? 0,

      qualified:
          (json['qualified'] as num?)?.toInt() ?? 0,

      rewarded:
          (json['rewarded'] as num?)?.toInt() ?? 0,

      totalRewards:
          double.tryParse(
                json['total_rewards']?.toString() ?? '0',
              ) ??
              0,

      rewardCurrency:
          json['reward_currency']?.toString() ?? 'USD',
    );
  }
}
class ReferralSummary {
  final String referralCode;
  final int totalReferrals;
  final int pending;
  final int qualified;
  final int rewarded;
  final double totalRewards;
  final String rewardCurrency;

  const ReferralSummary({
    required this.referralCode,
    required this.totalReferrals,
    required this.pending,
    required this.qualified,
    required this.rewarded,
    required this.totalRewards,
    required this.rewardCurrency,
  });
}
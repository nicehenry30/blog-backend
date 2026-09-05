class Referral {
  final int id;
  final String referralCode;
  final String status;
  final double rewardAmount;
  final String rewardCurrency;
  final DateTime? qualifiedAt;
  final DateTime? rewardedAt;
  final ReferredUser? referredUser;

  const Referral({
    required this.id,
    required this.referralCode,
    required this.status,
    required this.rewardAmount,
    required this.rewardCurrency,
    this.qualifiedAt,
    this.rewardedAt,
    this.referredUser,
  });
}

class ReferredUser {
  final int id;
  final String name;
  final String email;

  const ReferredUser({
    required this.id,
    required this.name,
    required this.email,
  });
}
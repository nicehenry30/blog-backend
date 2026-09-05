import '../../domain/entities/referral.dart';

class ReferralModel extends Referral {
  const ReferralModel({
    required super.id,
    required super.referralCode,
    required super.status,
    required super.rewardAmount,
    required super.rewardCurrency,
    super.qualifiedAt,
    super.rewardedAt,
    super.referredUser,
  });

  factory ReferralModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final referredUserJson =
        json['referred_user'] as Map<String, dynamic>?;

    return ReferralModel(
      id: json['id'] as int,
      referralCode:
          json['referral_code'] as String,
      status: json['status'] as String,
      rewardAmount:
          double.tryParse(
                json['reward_amount']?.toString() ?? '0',
              ) ??
              0,
      rewardCurrency:
          json['reward_currency'] as String? ?? 'USD',
      qualifiedAt: json['qualified_at'] != null
          ? DateTime.tryParse(
              json['qualified_at'].toString(),
            )
          : null,
      rewardedAt: json['rewarded_at'] != null
          ? DateTime.tryParse(
              json['rewarded_at'].toString(),
            )
          : null,
      referredUser: referredUserJson != null
          ? ReferredUser(
              id: referredUserJson['id'] as int,
              name:
                  referredUserJson['name'] as String,
              email:
                  referredUserJson['email'] as String,
            )
          : null,
    );
  }
}
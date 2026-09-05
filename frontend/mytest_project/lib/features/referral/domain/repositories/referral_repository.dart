import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/referral.dart';
import '../entities/referral_summary.dart';

abstract interface class ReferralRepository {
  Future<Either<Failure, ReferralSummary>>
      getReferralSummary();

  Future<Either<Failure, List<Referral>>>
      getReferrals();
}
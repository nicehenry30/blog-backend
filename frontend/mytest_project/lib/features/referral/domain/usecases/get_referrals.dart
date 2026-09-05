import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/referral.dart';
import '../repositories/referral_repository.dart';

class GetReferrals {
  final ReferralRepository repository;

  GetReferrals(this.repository);

  Future<Either<Failure, List<Referral>>> call() {
    return repository.getReferrals();
  }
}
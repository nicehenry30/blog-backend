import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/referral_summary.dart';
import '../repositories/referral_repository.dart';

class GetReferralSummary {
  final ReferralRepository repository;

  GetReferralSummary(this.repository);

  Future<Either<Failure, ReferralSummary>> call() {
    return repository.getReferralSummary();
  }
}
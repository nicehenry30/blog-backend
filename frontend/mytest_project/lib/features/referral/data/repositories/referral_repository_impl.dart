import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';

import '../../domain/entities/referral.dart';
import '../../domain/entities/referral_summary.dart';
import '../../domain/repositories/referral_repository.dart';

import '../datasources/referral_remote_data_source.dart';

class ReferralRepositoryImpl
    implements ReferralRepository {
  final ReferralRemoteDataSource remoteDataSource;

  ReferralRepositoryImpl(
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, ReferralSummary>>
      getReferralSummary() async {
    try {
      final result =
          await remoteDataSource
              .getReferralSummary();

      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Referral>>>
      getReferrals() async {
    try {
      final result =
          await remoteDataSource.getReferrals();

      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
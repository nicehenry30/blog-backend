import 'package:fpdart/fpdart.dart';

import 'package:mytest_project/core/error/failures.dart';
import 'package:mytest_project/core/usecase/usecase.dart';

import 'package:mytest_project/features/risk_settings/domain/entities/risk_settings.dart';
import 'package:mytest_project/features/risk_settings/domain/repository/risk_settings_repository.dart';

class GetRiskSettings
    implements UseCase<RiskSettings, NoParams> {
  final RiskSettingsRepository repository;

  GetRiskSettings(this.repository);

  @override
  Future<Either<Failure, RiskSettings>> call(
    NoParams params,
  ) {
    return repository.getRiskSettings();
  }
}
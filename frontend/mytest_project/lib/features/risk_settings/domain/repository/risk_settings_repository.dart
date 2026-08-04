import 'package:fpdart/fpdart.dart';

import 'package:mytest_project/core/error/failures.dart';
import 'package:mytest_project/features/risk_settings/domain/entities/risk_settings.dart';

abstract interface class RiskSettingsRepository {
  Future<Either<Failure, RiskSettings>> getRiskSettings();

  Future<Either<Failure, RiskSettings>> updateRiskSettings(
    RiskSettings settings,
  );
}
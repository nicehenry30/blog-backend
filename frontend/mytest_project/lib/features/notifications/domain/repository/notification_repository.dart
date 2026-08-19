import 'package:fpdart/fpdart.dart';
import 'package:mytest_project/core/error/failures.dart';

abstract interface class NotificationRepository {
  Future<Either<Failure, void>> registerDeviceToken({
    required String fcmToken,
    String? platform,
    String? deviceName,
  });

  Future<Either<Failure, void>> removeDeviceToken({
    required String fcmToken,
  });
}
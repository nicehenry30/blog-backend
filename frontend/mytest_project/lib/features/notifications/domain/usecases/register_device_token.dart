import 'package:fpdart/fpdart.dart';
import 'package:mytest_project/core/error/failures.dart';
import 'package:mytest_project/features/notifications/domain/repository/notification_repository.dart';

class RegisterDeviceToken {
  final NotificationRepository repository;

  RegisterDeviceToken(
    this.repository,
  );

  Future<Either<Failure, void>> call({
    required String fcmToken,
    String? platform,
    String? deviceName,
  }) {
    return repository.registerDeviceToken(
      fcmToken: fcmToken,
      platform: platform,
      deviceName: deviceName,
    );
  }
}
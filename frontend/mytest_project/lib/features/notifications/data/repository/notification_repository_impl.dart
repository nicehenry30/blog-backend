import 'package:fpdart/fpdart.dart';
import 'package:mytest_project/core/error/exceptions.dart';
import 'package:mytest_project/core/error/failures.dart';
import 'package:mytest_project/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:mytest_project/features/notifications/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl
    implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, void>> registerDeviceToken({
    required String fcmToken,
    String? platform,
    String? deviceName,
  }) async {
    try {
      await remoteDataSource.registerDeviceToken(
        fcmToken: fcmToken,
        platform: platform,
        deviceName: deviceName,
      );

      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> removeDeviceToken({
    required String fcmToken,
  }) async {
    try {
      await remoteDataSource.removeDeviceToken(
        fcmToken: fcmToken,
      );

      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }
}
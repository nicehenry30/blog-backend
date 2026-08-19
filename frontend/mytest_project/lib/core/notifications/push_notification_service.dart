import 'dart:developer' as developer;

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Initialize Firebase Cloud Messaging.
  Future<void> initialize({
    required Future<void> Function(String token) onTokenReceived,
  }) async {
    await _requestPermission();

    final token = await _messaging.getToken();

    if (token != null) {
      developer.log(
        'FCM TOKEN: $token',
        name: 'PushNotificationService',
      );

      await onTokenReceived(token);
    }

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        developer.log(
          'Foreground notification received.',
          name: 'PushNotificationService',
        );

        developer.log(
          'Title: ${message.notification?.title}',
          name: 'PushNotificationService',
        );

        developer.log(
          'Body: ${message.notification?.body}',
          name: 'PushNotificationService',
        );
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        developer.log(
          'Notification opened.',
          name: 'PushNotificationService',
        );

        developer.log(
          'Data: ${message.data}',
          name: 'PushNotificationService',
        );
      },
    );

    _messaging.onTokenRefresh.listen(
      (newToken) async {
        developer.log(
          'FCM token refreshed.',
          name: 'PushNotificationService',
        );

        await onTokenReceived(newToken);
      },
    );
  }

  /// Request notification permission from the user.
  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    developer.log(
      'Notification permission: ${settings.authorizationStatus}',
      name: 'PushNotificationService',
    );
  }
}
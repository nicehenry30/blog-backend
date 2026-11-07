import 'package:mytest_project/core/config/api_config.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mytest_project/core/error/exceptions.dart';
import 'package:mytest_project/core/storage/local_storage.dart';

abstract interface class NotificationRemoteDataSource {
  Future<void> registerDeviceToken({
    required String fcmToken,
    String? platform,
    String? deviceName,
  });

  Future<void> removeDeviceToken({
    required String fcmToken,
  });
}

class NotificationRemoteDataSourceImpl
    implements NotificationRemoteDataSource {
  final http.Client client;
  final LocalStorage localStorage;

  NotificationRemoteDataSourceImpl(
    this.client,
    this.localStorage,
  );

  static const String baseUrl =
      ApiConfig.baseUrl;

  @override
  Future<void> registerDeviceToken({
    required String fcmToken,
    String? platform,
    String? deviceName,
  }) async {
    final token = localStorage.getToken();

    final response = await client.post(
      Uri.parse('$baseUrl/device-token'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'fcm_token': fcmToken,
        'platform': platform,
        'device_name': deviceName,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return;
    }

    throw ServerException(
      message: data['message'] ??
          'Failed to register device token',
    );
  }

  @override
  Future<void> removeDeviceToken({
    required String fcmToken,
  }) async {
    final token = localStorage.getToken();

    final response = await client.delete(
      Uri.parse('$baseUrl/device-token'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'fcm_token': fcmToken,
      }),
    );

    if (response.statusCode == 200) {
      return;
    }

    final data = jsonDecode(response.body);

    throw ServerException(
      message: data['message'] ??
          'Failed to remove device token',
    );
  }
}
import 'package:mytest_project/core/config/api_config.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:mytest_project/core/error/exceptions.dart';
import 'package:mytest_project/core/storage/local_storage.dart';
import 'package:mytest_project/features/guardian/domain/entities/guardian_account.dart';

abstract interface class GuardianRemoteDataSource {
  Future<GuardianAccount> getGuardianAccount(
    String platform,
  );

  Future<String> generateConnectionCode(
    String platform,
  );

  Future<void> disconnectGuardian(
    String platform,
  );
}

class GuardianRemoteDataSourceImpl
    implements GuardianRemoteDataSource {
  final http.Client client;
  final LocalStorage localStorage;

  GuardianRemoteDataSourceImpl(
    this.client,
    this.localStorage,
  );

  static const String baseUrl =
      ApiConfig.baseUrl;

  @override
  Future<GuardianAccount> getGuardianAccount(
    String platform,
  ) async {
    final token = localStorage.getToken();

    final response = await client.get(
      Uri.parse(
        '$baseUrl/guardian?platform=$platform',
      ),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return GuardianAccount(
        id: data['id'],
        platform: data['platform'] ?? platform,
        accountNumber:
            data['account_number']?.toString(),
        broker: data['broker'],
        isConnected:
            data['is_connected'] ?? false,
        isEnabled:
            data['is_enabled'] ?? false,
        balance:
            (data['balance'] as num? ?? 0)
                .toDouble(),
        equity:
            (data['equity'] as num? ?? 0)
                .toDouble(),
        currentDrawdown:
            (data['current_drawdown'] as num? ?? 0)
                .toDouble(),
        openPositions:
            (data['open_positions'] as num? ?? 0)
                .toInt(),
        dailyProfitLoss:
            (data['daily_profit_loss'] as num? ?? 0)
                .toDouble(),
      );
    }

    throw ServerException(
      message:
          data['message'] ??
          'Failed to load Guardian account',
    );
  }

  @override
  Future<String> generateConnectionCode(
    String platform,
  ) async {
    final token = localStorage.getToken();

    final response = await client.post(
      Uri.parse(
        '$baseUrl/guardian/connection-code',
      ),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'platform': platform,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      final code = data['code'];

      if (code is String && code.isNotEmpty) {
        return code;
      }

      throw ServerException(
        message:
            'Guardian connection code was not returned.',
      );
    }

    throw ServerException(
      message:
          data['message'] ??
          'Failed to generate Guardian connection code',
    );
  }

  @override
  Future<void> disconnectGuardian(
    String platform,
  ) async {
    final token = localStorage.getToken();

    final response = await client.delete(
      Uri.parse(
        '$baseUrl/guardian/disconnect?platform=$platform',
      ),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return;
    }

    final data = jsonDecode(response.body);

    throw ServerException(
      message:
          data['message'] ??
          'Failed to disconnect Guardian account',
    );
  }
}
import 'package:mytest_project/core/config/api_config.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:mytest_project/core/error/exceptions.dart';
import 'package:mytest_project/core/storage/local_storage.dart';
import 'package:mytest_project/features/risk_settings/domain/entities/risk_settings.dart';

abstract interface class RiskSettingsRemoteDataSource {
  Future<RiskSettings> getRiskSettings();

  Future<RiskSettings> updateRiskSettings(
    RiskSettings settings,
  );
}

class RiskSettingsRemoteDataSourceImpl
    implements RiskSettingsRemoteDataSource {
  final http.Client client;
  final LocalStorage localStorage;

  RiskSettingsRemoteDataSourceImpl(
    this.client,
    this.localStorage,
  );

  static const String baseUrl =
      ApiConfig.baseUrl;

  @override
  Future<RiskSettings> getRiskSettings() async {
    final token = localStorage.getToken();

    final response = await client.get(
      Uri.parse('$baseUrl/risk-settings'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return RiskSettings(
        riskPerTrade:
            (data['risk_per_trade'] as num).toDouble(),
        dailyLossLimit:
            (data['daily_loss_limit'] as num).toDouble(),
        maxDrawdown:
            (data['max_drawdown'] as num).toDouble(),
      );
    }

    throw ServerException(
      message:
          data['message'] ?? 'Failed to load risk settings',
    );
  }

  @override
  Future<RiskSettings> updateRiskSettings(
    RiskSettings settings,
  ) async {
    final token = localStorage.getToken();

    final response = await client.put(
      Uri.parse('$baseUrl/risk-settings'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'risk_per_trade': settings.riskPerTrade,
        'daily_loss_limit': settings.dailyLossLimit,
        'max_drawdown': settings.maxDrawdown,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return RiskSettings(
        riskPerTrade:
            (data['risk_per_trade'] as num).toDouble(),
        dailyLossLimit:
            (data['daily_loss_limit'] as num).toDouble(),
        maxDrawdown:
            (data['max_drawdown'] as num).toDouble(),
      );
    }

    throw ServerException(
      message:
          data['message'] ?? 'Failed to update risk settings',
    );
  }
}
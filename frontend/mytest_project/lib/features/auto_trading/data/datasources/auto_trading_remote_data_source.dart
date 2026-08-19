import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:mytest_project/core/error/exceptions.dart';
import 'package:mytest_project/core/storage/local_storage.dart';
import 'package:mytest_project/features/auto_trading/data/models/auto_trading_settings_model.dart';

abstract interface class AutoTradingRemoteDataSource {
  Future<AutoTradingSettingsModel> getAutoTradingSettings();

  Future<AutoTradingSettingsModel> updateAutoTrading(
    bool enabled,
  );

  Future<AutoTradingSettingsModel> updateAutoTradingPreferences({
    double? minimumSignalQuality,
    double? minimumAiConfidence,
    bool? allowBuy,
    bool? allowSell,
    bool? requireAiConfirmation,
    bool? requireStopLoss,
    bool? requireTakeProfit,
  });
}

class AutoTradingRemoteDataSourceImpl
    implements AutoTradingRemoteDataSource {
  final http.Client client;
  final LocalStorage localStorage;

  AutoTradingRemoteDataSourceImpl(
    this.client,
    this.localStorage,
  );

  static const String baseUrl =
      'http://127.0.0.1:8000/api';

  // ============================================================
  // HEADERS
  // ============================================================

  Map<String, String> _headers(String? token) {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ============================================================
  // GET SETTINGS
  // ============================================================

  @override
  Future<AutoTradingSettingsModel>
      getAutoTradingSettings() async {
    final token = localStorage.getToken();

    final response = await client.get(
      Uri.parse('$baseUrl/settings'),
      headers: _headers(token),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return AutoTradingSettingsModel.fromJson(data);
    }

    throw ServerException(
      message:
          data['message'] ??
          'Failed to load Auto Trading settings',
    );
  }

  // ============================================================
  // UPDATE MASTER SWITCH
  // ============================================================

  @override
  Future<AutoTradingSettingsModel>
      updateAutoTrading(bool enabled) async {
    final token = localStorage.getToken();

    final response = await client.put(
      Uri.parse('$baseUrl/settings/auto-trading'),
      headers: _headers(token),
      body: jsonEncode({
        'auto_trading_enabled': enabled,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return AutoTradingSettingsModel.fromJson(data);
    }

    throw ServerException(
      message:
          data['message'] ??
          'Failed to update Auto Trading',
    );
  }

  // ============================================================
  // UPDATE PREFERENCES
  // ============================================================

  @override
  Future<AutoTradingSettingsModel>
      updateAutoTradingPreferences({
    double? minimumSignalQuality,
    double? minimumAiConfidence,
    bool? allowBuy,
    bool? allowSell,
    bool? requireAiConfirmation,
    bool? requireStopLoss,
    bool? requireTakeProfit,
  }) async {
    final token = localStorage.getToken();

    final Map<String, dynamic> body = {};

    if (minimumSignalQuality != null) {
      body['minimum_signal_quality'] =
          minimumSignalQuality;
    }

    if (minimumAiConfidence != null) {
      body['minimum_ai_confidence'] =
          minimumAiConfidence;
    }

    if (allowBuy != null) {
      body['allow_buy'] = allowBuy;
    }

    if (allowSell != null) {
      body['allow_sell'] = allowSell;
    }

    if (requireAiConfirmation != null) {
      body['require_ai_confirmation'] =
          requireAiConfirmation;
    }

    if (requireStopLoss != null) {
      body['require_stop_loss'] = requireStopLoss;
    }

    if (requireTakeProfit != null) {
      body['require_take_profit'] =
          requireTakeProfit;
    }

    final response = await client.put(
      Uri.parse(
        '$baseUrl/settings/auto-trading/preferences',
      ),
      headers: _headers(token),
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return AutoTradingSettingsModel.fromJson(data);
    }

    throw ServerException(
      message:
          data['message'] ??
          'Failed to update Auto Trading preferences',
    );
  }
}
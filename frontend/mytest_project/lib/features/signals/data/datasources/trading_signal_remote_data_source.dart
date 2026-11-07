import 'package:mytest_project/core/config/api_config.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:mytest_project/core/error/exceptions.dart';
import 'package:mytest_project/core/storage/local_storage.dart';

import '../models/ai_signal_confirmation_model.dart';
import '../models/trading_signal_model.dart';

abstract interface class TradingSignalRemoteDataSource {
  Future<List<TradingSignalModel>> getSignals();

  Future<TradingSignalModel> getSignalDetails(int signalId);

  Future<AiSignalConfirmationModel> getAiConfirmation(
    int signalId,
  );
}

class TradingSignalRemoteDataSourceImpl
    implements TradingSignalRemoteDataSource {
  final http.Client client;

  final LocalStorage localStorage;

  TradingSignalRemoteDataSourceImpl(
    this.client,
    this.localStorage,
  );

  static const String baseUrl =
      ApiConfig.baseUrl;

  @override
  Future<List<TradingSignalModel>> getSignals() async {
    final token = localStorage.getToken();

    final response = await client.get(
      Uri.parse('$baseUrl/signals'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List signals = data['data'] as List;

      return signals
          .map(
            (json) => TradingSignalModel.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    }

    throw ServerException(
      message: data['message'] ??
          'Failed to retrieve signals.',
    );
  }

  @override
  Future<TradingSignalModel> getSignalDetails(
    int signalId,
  ) async {
    final token = localStorage.getToken();

    final response = await client.get(
      Uri.parse('$baseUrl/signals/$signalId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return TradingSignalModel.fromJson(
        data['data'],
      );
    }

    throw ServerException(
      message: data['message'] ??
          'Failed to retrieve signal.',
    );
  }

  @override
  Future<AiSignalConfirmationModel> getAiConfirmation(
    int signalId,
  ) async {
    final token = localStorage.getToken();

    final response = await client.get(
      Uri.parse(
        '$baseUrl/signals/$signalId/ai-confirmation',
      ),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return AiSignalConfirmationModel.fromJson(
        data['ai'] as Map<String, dynamic>,
      );
    }

    throw ServerException(
      message: data['message'] ??
          'Failed to retrieve AI confirmation.',
    );
  }
}
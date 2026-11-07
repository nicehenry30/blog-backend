import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mytest_project/core/error/exceptions.dart';
import 'package:mytest_project/core/storage/local_storage.dart';
import 'package:mytest_project/core/config/api_config.dart';

import '../models/ai_market_analysis_model.dart';

abstract interface class AiMarketAnalysisRemoteDataSource {
  Future<AiMarketAnalysisModel> analyzeMarket({
    required String symbol,
    required double accountBalance,
    required double riskPercent,
  });
}

class AiMarketAnalysisRemoteDataSourceImpl
    implements AiMarketAnalysisRemoteDataSource {
  final http.Client client;
  final LocalStorage localStorage;

  AiMarketAnalysisRemoteDataSourceImpl(this.client, this.localStorage);

  static const String baseUrl = ApiConfig.baseUrl;

  @override
  Future<AiMarketAnalysisModel> analyzeMarket({
    required String symbol,
    required double accountBalance,
    required double riskPercent,
  }) async {
    final token = localStorage.getToken();

    if (token == null || token.isEmpty) {
      throw ServerException(message: 'Authentication token not found.');
    }

    final response = await client.post(
      Uri.parse('$baseUrl/ai/market-analysis'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'symbol': symbol,
        'account_balance': accountBalance,
        'risk_percent': riskPercent,
      }),
    );

    if (response.statusCode != 200) {
      throw ServerException(
        message: 'Failed to analyze market: ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw ServerException(message: 'Invalid market analysis response.');
    }

    final data = decoded['data'];

    if (data is! Map<String, dynamic>) {
      throw ServerException(message: 'Market analysis data is missing.');
    }

    return AiMarketAnalysisModel.fromJson(data);
  }
}

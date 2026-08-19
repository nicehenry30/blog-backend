import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:mytest_project/core/error/exceptions.dart';
import 'package:mytest_project/core/storage/local_storage.dart';

import 'package:mytest_project/features/market_alerts/data/datasources/market_alert_remote_data_source.dart';
import 'package:mytest_project/features/market_alerts/data/models/market_alert_model.dart';

class MarketAlertRemoteDataSourceImpl
    implements MarketAlertRemoteDataSource {
  final http.Client client;
  final LocalStorage localStorage;

  MarketAlertRemoteDataSourceImpl(
    this.client,
    this.localStorage,
  );

  static const String baseUrl =
      'http://127.0.0.1:8000/api';

  @override
  Future<List<MarketAlertModel>> getMarketAlerts() async {
    final token = localStorage.getToken();

    final response = await client.get(
      Uri.parse('$baseUrl/market-alerts'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> alerts = data['data'];

      return alerts
          .map(
            (json) => MarketAlertModel.fromJson(
              json,
            ),
          )
          .toList();
    }

    throw ServerException(
      message:
          data['message'] ??
          'Failed to load market alerts',
    );
  }
}
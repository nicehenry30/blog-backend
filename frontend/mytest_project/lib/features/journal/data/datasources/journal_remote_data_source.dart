import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mytest_project/core/error/exceptions.dart';
import 'package:mytest_project/core/storage/local_storage.dart';
import 'package:mytest_project/features/journal/domain/entities/trade.dart';

abstract interface class JournalRemoteDataSource {
  Future<List<Trade>> getTrades();

  Future<void> addTrade(Trade trade);

  Future<void> updateTrade(Trade trade);

  Future<void> deleteTrade(int tradeId);
}

class JournalRemoteDataSourceImpl implements JournalRemoteDataSource {
  final http.Client client;
  final LocalStorage localStorage;

  JournalRemoteDataSourceImpl(
    this.client,
    this.localStorage,
  );

  static const String baseUrl = 'http://127.0.0.1:8000/api';

  @override
  Future<List<Trade>> getTrades() async {
    final token = localStorage.getToken();

    final response = await client.get(
      Uri.parse('$baseUrl/trades'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final tradesJson = data['trades'] as List;

      return tradesJson
          .map(
            (json) => Trade.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    }

    throw ServerException(
      message: data['message'] ?? 'Failed to retrieve trades',
    );
  }

  @override
  Future<void> addTrade(Trade trade) async {
    final token = localStorage.getToken();

    final response = await client.post(
      Uri.parse('$baseUrl/trades'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        trade.toJson(),
      ),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return;
    }

    throw ServerException(
      message: data['message'] ?? 'Failed to add trade',
    );
  }

  @override
  Future<void> updateTrade(Trade trade) async {
    if (trade.id == null) {
      throw ServerException(
        message: 'Cannot update a trade without an ID',
      );
    }

    final token = localStorage.getToken();

    final response = await client.put(
      Uri.parse('$baseUrl/trades/${trade.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        trade.toJson(),
      ),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return;
    }

    throw ServerException(
      message: data['message'] ?? 'Failed to update trade',
    );
  }

  @override
  Future<void> deleteTrade(int tradeId) async {
    final token = localStorage.getToken();

    final response = await client.delete(
      Uri.parse('$baseUrl/trades/$tradeId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    }

    final data = jsonDecode(response.body);

    throw ServerException(
      message: data['message'] ?? 'Failed to delete trade',
    );
  }
}
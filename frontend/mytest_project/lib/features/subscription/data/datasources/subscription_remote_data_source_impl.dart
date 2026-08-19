import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../../core/storage/local_storage.dart';

import '../models/plan_model.dart';
import '../models/subscription_model.dart';
import 'subscription_remote_data_source.dart';

class SubscriptionRemoteDataSourceImpl
    implements SubscriptionRemoteDataSource {
  final http.Client client;
  final LocalStorage localStorage;

  SubscriptionRemoteDataSourceImpl(
    this.client,
    this.localStorage,
  );

  static const String baseUrl =
      'http://127.0.0.1:8000/api';

  @override
  Future<List<PlanModel>> getPlans() async {
   final token = localStorage.getToken();

    final response = await client.get(
      Uri.parse('$baseUrl/plans'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> plans = data['data'];

      return plans
          .map(
            (e) => PlanModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();
    }

    throw ServerException(
      message:
          data['message'] ??
          'Failed to load plans',
    );
  }

  @override
  Future<SubscriptionModel>
      getCurrentSubscription() async {
   final token = localStorage.getToken();

    final response = await client.get(
      Uri.parse('$baseUrl/subscription'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return SubscriptionModel.fromJson(
        data['data'],
      );
    }

    throw ServerException(
      message:
          data['message'] ??
          'Failed to load subscription',
    );
  }

  @override
  Future<String> initializePayment(
    int planId,
  ) async {
    final token = localStorage.getToken();

    final response = await client.post(
      Uri.parse(
        '$baseUrl/payments/initialize',
      ),
      headers: {
        'Content-Type':
            'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'plan_id': planId,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['data']
          ['authorization_url'];
    }

    throw ServerException(
      message:
          data['message'] ??
          'Failed to initialize payment',
    );
  }

  @override
  Future<SubscriptionModel> verifyPayment(
    String reference,
  ) async {
    final token = localStorage.getToken();

    final response = await client.post(
      Uri.parse(
        '$baseUrl/payments/verify',
      ),
      headers: {
        'Content-Type':
            'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'reference': reference,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return SubscriptionModel.fromJson(
        data['subscription'],
      );
    }

    throw ServerException(
      message:
          data['message'] ??
          'Payment verification failed',
    );
  }
}
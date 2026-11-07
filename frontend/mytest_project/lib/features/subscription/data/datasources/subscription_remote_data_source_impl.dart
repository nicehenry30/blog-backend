import 'package:mytest_project/core/config/api_config.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../../core/storage/local_storage.dart';

import '../../domain/entities/payment_initialization.dart';

import '../models/crypto_payment_model.dart';
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
      ApiConfig.baseUrl;

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
        data['subscription']
            as Map<String, dynamic>,
      );
    }

    if (response.statusCode == 404) {
      throw ServerException(
        message:
            'No active subscription found.',
      );
    }

    throw ServerException(
      message:
          data['message'] ??
          'Failed to load subscription',
    );
  }

  @override
  Future<PaymentInitialization>
      initializePayment(
    int planId,
  ) async {
    final token = localStorage.getToken();

    final response = await client.post(
      Uri.parse(
        '$baseUrl/payments/initialize',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'plan_id': planId,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return PaymentInitialization(
        authorizationUrl:
            data['authorization_url']
                as String,
        accessCode:
            data['access_code']
                as String,
        reference:
            data['reference']
                as String,
        isUpgrade:
            data['is_upgrade']
                as bool? ??
            false,
      );
    }

    throw ServerException(
      message:
          data['message'] ??
          'Failed to initialize payment',
    );
  }

  @override
  Future<CryptoPaymentModel>
      initializeCryptoPayment(
    int planId,
  ) async {
    final token = localStorage.getToken();

    final response = await client.post(
      Uri.parse(
        '$baseUrl/payments/crypto/initialize',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'plan_id': planId,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return CryptoPaymentModel.fromJson(
        data as Map<String, dynamic>,
      );
    }

    throw ServerException(
      message:
          data['message'] ??
          'Failed to initialize crypto payment',
    );
  }

  @override
  Future<void> submitCryptoTransaction(
    int paymentId,
    String transactionHash,
  ) async {
    final token = localStorage.getToken();

    final response = await client.post(
      Uri.parse(
        '$baseUrl/payments/crypto/submit',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'payment_id': paymentId,
        'transaction_hash':
            transactionHash.trim(),
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return;
    }

    throw ServerException(
      message:
          data['message'] ??
          'Failed to submit crypto transaction',
    );
  }

  @override
  Future<SubscriptionModel>
      verifyPayment(
    String reference,
  ) async {
    final token = localStorage.getToken();

    final response = await client.post(
      Uri.parse(
        '$baseUrl/payments/verify',
      ),
      headers: {
        'Content-Type': 'application/json',
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
        data['subscription']
            as Map<String, dynamic>,
      );
    }

    throw ServerException(
      message:
          data['message'] ??
          'Payment verification failed',
    );
  }

  @override
  Future<SubscriptionModel>
      startTrial(
    int planId,
    String paymentProvider,
    String paymentMethodId,
  ) async {
    final token = localStorage.getToken();

    final response = await client.post(
      Uri.parse(
        '$baseUrl/subscription/trial',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'plan_id': planId,
        'payment_provider':
            paymentProvider,
        'payment_method_id':
            paymentMethodId,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return SubscriptionModel.fromJson(
        data['trial']
            as Map<String, dynamic>,
      );
    }

    throw ServerException(
      message:
          data['message'] ??
          'Failed to start free trial',
    );
  }
}
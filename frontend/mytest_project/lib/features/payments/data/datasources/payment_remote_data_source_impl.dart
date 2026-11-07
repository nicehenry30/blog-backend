import 'package:mytest_project/core/config/api_config.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../../core/storage/local_storage.dart';

import '../models/payment_model.dart';
import 'payment_remote_data_source.dart';

class PaymentRemoteDataSourceImpl
    implements PaymentRemoteDataSource {
  final http.Client client;

  final LocalStorage localStorage;

  PaymentRemoteDataSourceImpl(
    this.client,
    this.localStorage,
  );

  static const baseUrl =
      ApiConfig.baseUrl;

  @override
  Future<List<PaymentModel>>
      getPayments() async {
    final token =
         localStorage.getToken();

    final response = await client.get(
      Uri.parse('$baseUrl/payments'),
      headers: {
        'Accept': 'application/json',
        'Authorization':
            'Bearer $token',
      },
    );

    final data =
        jsonDecode(response.body);

    if (response.statusCode == 200) {
      return (data['data'] as List)
          .map(
            (e) => PaymentModel.fromJson(
              e,
            ),
          )
          .toList();
    }

    throw ServerException(
      message:
          data['message'] ??
          'Failed to load payments.',
    );
  }

  @override
  Future<PaymentModel> getPayment(
    int paymentId,
  ) async {
    final token =
        localStorage.getToken();

    final response = await client.get(
      Uri.parse(
        '$baseUrl/payments/$paymentId',
      ),
      headers: {
        'Accept': 'application/json',
        'Authorization':
            'Bearer $token',
      },
    );

    final data =
        jsonDecode(response.body);

    if (response.statusCode == 200) {
      return PaymentModel.fromJson(
        data['data'],
      );
    }

    throw ServerException(
      message:
          data['message'] ??
          'Failed to load payment.',
    );
  }
}
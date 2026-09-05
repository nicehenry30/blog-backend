import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../../core/storage/local_storage.dart';

import '../models/referral_model.dart';
import '../models/referral_summary_model.dart';
import 'referral_remote_data_source.dart';

class ReferralRemoteDataSourceImpl
    implements ReferralRemoteDataSource {
  final http.Client client;
  final LocalStorage localStorage;

  ReferralRemoteDataSourceImpl(
    this.client,
    this.localStorage,
  );

  static const String baseUrl =
      'http://127.0.0.1:8000/api';

  Map<String, String> get _headers {
    final token = localStorage.getToken();

    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<ReferralSummaryModel> getReferralSummary() async {
    final response = await client.get(
      Uri.parse('$baseUrl/referral'),
      headers: _headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return ReferralSummaryModel.fromJson(
        data as Map<String, dynamic>,
      );
    }

    throw ServerException(
      message:
          data['message'] ??
          'Failed to load referral summary',
    );
  }

  @override
  Future<List<ReferralModel>> getReferrals() async {
    final response = await client.get(
      Uri.parse('$baseUrl/referrals'),
      headers: _headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> referrals =
          data['data'];

      return referrals
          .map(
            (e) => ReferralModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();
    }

    throw ServerException(
      message:
          data['message'] ??
          'Failed to load referrals',
    );
  }
}
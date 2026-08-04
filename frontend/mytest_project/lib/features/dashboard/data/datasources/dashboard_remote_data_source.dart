import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:mytest_project/core/error/exceptions.dart';
import 'package:mytest_project/core/storage/local_storage.dart';
import 'package:mytest_project/features/dashboard/data/models/dashboard_model.dart';
import 'package:mytest_project/features/dashboard/domain/entities/dashboard.dart';

abstract interface class DashboardRemoteDataSource {
  Future<Dashboard> getDashboard();
}

class DashboardRemoteDataSourceImpl
    implements DashboardRemoteDataSource {
  final http.Client client;
  final LocalStorage localStorage;

  DashboardRemoteDataSourceImpl(
    this.client,
    this.localStorage,
  );

  static const String baseUrl =
      'http://127.0.0.1:8000/api';

  @override
  Future<Dashboard> getDashboard() async {
    final token = localStorage.getToken();

    final response = await client.get(
      Uri.parse('$baseUrl/dashboard'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return DashboardModel.fromJson(
        data as Map<String, dynamic>,
      );
    }

    throw ServerException(
      message:
          data['message'] ?? 'Failed to load dashboard',
    );
  }
}
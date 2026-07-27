import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mytest_project/core/error/exceptions.dart';
import 'package:mytest_project/features/auth/data/models/auth_user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<AuthUserModel> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<AuthUserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl(this.client);

  static const String baseUrl = 'http://10.0.2.2:8000';

  @override
  Future<AuthUserModel> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return AuthUserModel.fromJson(responseData);
    }

    throw ServerException(
      message: responseData['message'] ?? 'Unable to create account',
    );
  }

  @override
  Future<AuthUserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return AuthUserModel.fromJson(responseData);
    }

    throw ServerException(
      message: responseData['message'] ?? 'Unable to login',
    );
  }
}

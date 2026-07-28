import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mytest_project/core/error/exceptions.dart';
import 'package:mytest_project/features/auth/domain/entities/auth_user.dart';

abstract interface class AuthRemoteDataSource {
  Future<AuthUser> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<AuthUser> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<AuthUser> getCurrentUser({required String token});

  Future<void> logout({required String token});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl(this.client);

  static const String baseUrl = 'http://127.0.0.1:8000/api';

  @override
  Future<AuthUser> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/register'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return AuthUser.fromJson(data['user'], token: data['token']);
    }

    throw ServerException(message: data['message'] ?? 'Registration failed');
  }

  @override
  Future<AuthUser> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return AuthUser.fromJson(data['user'], token: data['token']);
    }

    throw ServerException(message: data['message'] ?? 'Login failed');
  }

  
 @override
Future<AuthUser> getCurrentUser({required String token}) async {
  final response = await client.get(
    Uri.parse('$baseUrl/user'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  final data = jsonDecode(response.body);

  if (response.statusCode == 200) {
    return AuthUser.fromJson(
      data['user'],
      token: token,
    );
  }

  throw ServerException(
    message: data['message'] ?? 'Unable to get current user',
  );
}
  @override
  Future<void> logout({required String token}) async {
    final response = await client.post(
      Uri.parse('$baseUrl/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);

      throw ServerException(message: data['message'] ?? 'Logout failed');
    }
  }
}

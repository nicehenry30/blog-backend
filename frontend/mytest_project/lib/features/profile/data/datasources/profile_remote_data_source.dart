import 'package:mytest_project/core/config/api_config.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/storage/local_storage.dart';
import '../models/profile_model.dart';

abstract interface class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();

  Future<ProfileModel> updateProfile(
    ProfileModel profile,
  );
}

class ProfileRemoteDataSourceImpl
    implements ProfileRemoteDataSource {
  final http.Client client;
  final LocalStorage localStorage;

  ProfileRemoteDataSourceImpl(
    this.client,
    this.localStorage,
  );

  static const String baseUrl =
      ApiConfig.baseUrl;

  Future<Map<String, String>> _headers() async {
    final token = localStorage.getToken();

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<ProfileModel> getProfile() async {
    final response = await client.get(
      Uri.parse('$baseUrl/profile'),
      headers: await _headers(),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load profile: ${response.statusCode}',
      );
    }

    final data =
        jsonDecode(response.body) as Map<String, dynamic>;

    final user =
        data['user'] as Map<String, dynamic>;

    return ProfileModel.fromJson({
      'id': user['id'],
      'name': user['name'],
      'email': user['email'],
      'subscription':
          user['subscription'] ?? 'Free',
      'mt4_connected':
          user['mt4_connected'] ?? false,
      'mt5_connected':
          user['mt5_connected'] ?? false,
    });
  }

  @override
  Future<ProfileModel> updateProfile(
    ProfileModel profile,
  ) async {
    final response = await client.put(
      Uri.parse('$baseUrl/profile'),
      headers: await _headers(),
      body: jsonEncode({
        'name': profile.name,
        'email': profile.email,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to update profile: ${response.statusCode}',
      );
    }

    final data =
        jsonDecode(response.body) as Map<String, dynamic>;

    final user =
        data['user'] as Map<String, dynamic>;

    return ProfileModel.fromJson({
      'id': user['id'],
      'name': user['name'],
      'email': user['email'],
      'subscription':
          user['subscription'] ?? profile.subscription,
      'mt4_connected':
          user['mt4_connected'] ?? profile.mt4Connected,
      'mt5_connected':
          user['mt5_connected'] ?? profile.mt5Connected,
    });
  }
}
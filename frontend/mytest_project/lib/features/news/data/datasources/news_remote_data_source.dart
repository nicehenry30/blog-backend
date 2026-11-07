import 'package:mytest_project/core/config/api_config.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';

import '../models/news_model.dart';

abstract interface class NewsRemoteDataSource {
  Future<List<NewsModel>> getNews();

  Future<NewsModel> getNewsDetails(int newsId);
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final http.Client client;

  NewsRemoteDataSourceImpl(this.client);

  static const baseUrl = ApiConfig.baseUrl;

  @override
  Future<List<NewsModel>> getNews() async {
    final response = await client.get(
      Uri.parse('$baseUrl/news'),
      headers: {'Accept': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return (data['data'] as List).map((e) => NewsModel.fromJson(e)).toList();
    }

    throw ServerException(message: data['message'] ?? 'Failed to load news.');
  }

  @override
  Future<NewsModel> getNewsDetails(int newsId) async {
    throw UnimplementedError('News detail endpoint is not available yet.');
  }
}

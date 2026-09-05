import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mytest_project/core/error/exceptions.dart';
import 'package:mytest_project/core/storage/local_storage.dart';
import 'package:mytest_project/features/feedback/domain/entities/feedback.dart';

abstract interface class FeedbackRemoteDataSource {
  Future<List<Feedback>> getFeedback();

  Future<Feedback> submitFeedback({
    required String category,
    required String subject,
    required String message,
  });

  Future<Feedback> getFeedbackById(
    int feedbackId,
  );
}

class FeedbackRemoteDataSourceImpl
    implements FeedbackRemoteDataSource {
  final http.Client client;
  final LocalStorage localStorage;

  FeedbackRemoteDataSourceImpl(
    this.client,
    this.localStorage,
  );

  static const String baseUrl =
      'http://127.0.0.1:8000/api';

  Map<String, String> _headers(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  String _getToken() {
    final token = localStorage.getToken();

    if (token == null || token.trim().isEmpty) {
      throw ServerException(
        message: 'Authentication token not found.',
      );
    }

    return token;
  }

  Feedback _parseFeedback(
    Map<String, dynamic> json,
  ) {
    return Feedback(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      category: json['category'] as String,
      subject: json['subject'] as String,
      message: json['message'] as String,
      adminReply: json['admin_reply'] as String?,
      status: json['status'] as String,
      repliedAt: json['replied_at'] != null
          ? DateTime.parse(
              json['replied_at'] as String,
            )
          : null,
      createdAt: DateTime.parse(
        json['created_at'] as String,
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] as String,
      ),
    );
  }

  @override
  Future<List<Feedback>> getFeedback() async {
    final token = _getToken();

    final response = await client.get(
      Uri.parse('$baseUrl/feedback'),
      headers: _headers(token),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final items = data['data'] as List<dynamic>;

      return items
          .map(
            (item) => _parseFeedback(
              item as Map<String, dynamic>,
            ),
          )
          .toList();
    }

    throw ServerException(
      message:
          data['message'] ??
          'Unable to load feedback.',
    );
  }

  @override
  Future<Feedback> submitFeedback({
    required String category,
    required String subject,
    required String message,
  }) async {
    final token = _getToken();

    final response = await client.post(
      Uri.parse('$baseUrl/feedback'),
      headers: _headers(token),
      body: jsonEncode({
        'category': category,
        'subject': subject,
        'message': message,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return _parseFeedback(
        data['data'] as Map<String, dynamic>,
      );
    }

    throw ServerException(
      message:
          data['message'] ??
          'Unable to submit feedback.',
    );
  }

  @override
  Future<Feedback> getFeedbackById(
    int feedbackId,
  ) async {
    final token = _getToken();

    final response = await client.get(
      Uri.parse(
        '$baseUrl/feedback/$feedbackId',
      ),
      headers: _headers(token),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return _parseFeedback(
        data['data'] as Map<String, dynamic>,
      );
    }

    throw ServerException(
      message:
          data['message'] ??
          'Unable to load feedback.',
    );
  }
}
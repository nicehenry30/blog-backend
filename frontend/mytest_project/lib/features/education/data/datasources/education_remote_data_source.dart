import 'package:mytest_project/core/config/api_config.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:mytest_project/core/error/exceptions.dart';
import 'package:mytest_project/core/storage/local_storage.dart';
import 'package:mytest_project/features/education/data/models/course_model.dart';
import 'package:mytest_project/features/education/data/models/lesson_model.dart';
import 'package:mytest_project/features/education/data/models/progress_model.dart';

abstract interface class EducationRemoteDataSource {
  Future<List<CourseModel>> getCourses();

  Future<CourseModel> getCourseDetails(
    int courseId,
  );

  Future<List<LessonModel>> getLessons(
    int courseId,
  );

  Future<ProgressModel> getProgress(
    int courseId,
  );

  Future<void> updateProgress(
    int lessonId,
  );
}

class EducationRemoteDataSourceImpl
    implements EducationRemoteDataSource {
  final http.Client client;
  final LocalStorage localStorage;

  EducationRemoteDataSourceImpl(
    this.client,
    this.localStorage,
  );

  static const String baseUrl =
      ApiConfig.baseUrl;

  @override
  Future<List<CourseModel>> getCourses() async {
    final token = localStorage.getToken();

    final response = await client.get(
      Uri.parse('$baseUrl/courses'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final courses = data['data'] as List;

      return courses
          .map(
            (course) => CourseModel.fromJson(
              course as Map<String, dynamic>,
            ),
          )
          .toList();
    }

    throw ServerException(
      message:
          data['message'] ?? 'Failed to load courses',
    );
  }

  @override
  Future<CourseModel> getCourseDetails(
    int courseId,
  ) async {
    final token = localStorage.getToken();

    final response = await client.get(
      Uri.parse('$baseUrl/courses/$courseId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return CourseModel.fromJson(
        data['data'] as Map<String, dynamic>,
      );
    }

    throw ServerException(
      message:
          data['message'] ?? 'Failed to load course details',
    );
  }

  @override
Future<List<LessonModel>> getLessons(
  int courseId,
) async {
  final course = await getCourseDetails(courseId);

  return course.lessons
      .map(
        (lesson) => LessonModel(
          id: lesson.id,
          courseId: lesson.courseId,
          title: lesson.title,
          description: lesson.description,
          videoUrl: lesson.videoUrl,
          lessonOrder: lesson.lessonOrder,
          isPublished: lesson.isPublished,
        ),
      )
      .toList();
}

  @override
  Future<ProgressModel> getProgress(
    int courseId,
  ) async {
    throw ServerException(
      message: 'Progress API is not available yet.',
    );
  }

  @override
  Future<void> updateProgress(
    int lessonId,
  ) async {
    throw ServerException(
      message: 'Progress API is not available yet.',
    );
  }
}
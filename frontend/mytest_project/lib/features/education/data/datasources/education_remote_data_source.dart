import '../models/course_model.dart';
import '../models/lesson_model.dart';
import '../models/progress_model.dart';

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
  @override
  Future<List<CourseModel>> getCourses() async {
    throw UnimplementedError();
  }

  @override
  Future<CourseModel> getCourseDetails(
    int courseId,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<List<LessonModel>> getLessons(
    int courseId,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<ProgressModel> getProgress(
    int courseId,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateProgress(
    int lessonId,
  ) async {
    throw UnimplementedError();
  }
}
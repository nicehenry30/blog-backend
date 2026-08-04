import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';

import '../entities/course.dart';
import '../entities/lesson.dart';
import '../entities/progress.dart';

abstract interface class EducationRepository {
  Future<Either<Failure, List<Course>>> getCourses();

  Future<Either<Failure, Course>> getCourseDetails(
    int courseId,
  );

  Future<Either<Failure, List<Lesson>>> getLessons(
    int courseId,
  );

  Future<Either<Failure, Progress>> getProgress(
    int courseId,
  );

  Future<Either<Failure, void>> updateProgress(
    int lessonId,
  );
}
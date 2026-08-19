import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';

import '../../domain/entities/course.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/progress.dart';
import '../../domain/repository/education_repository.dart';

import '../datasources/education_remote_data_source.dart';

class EducationRepositoryImpl implements EducationRepository {
  final EducationRemoteDataSource remoteDataSource;

  const EducationRepositoryImpl(
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, List<Course>>> getCourses() async {
    try {
      final courses = await remoteDataSource.getCourses();

      return Right(courses);
    } catch (e) {
      return Left(
        Failure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, Course>> getCourseDetails(
    int courseId,
  ) async {
    try {
      final course =
          await remoteDataSource.getCourseDetails(courseId);

      return Right(course);
    } catch (e) {
      return Left(
        Failure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, List<Lesson>>> getLessons(
    int courseId,
  ) async {
    try {
      final lessons =
          await remoteDataSource.getLessons(courseId);

      return Right(lessons);
    } catch (e) {
      return Left(
        Failure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, Progress>> getProgress(
    int courseId,
  ) async {
    try {
      final progress =
          await remoteDataSource.getProgress(courseId);

      return Right(progress);
    } catch (e) {
      return Left(
        Failure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateProgress(
    int lessonId,
  ) async {
    try {
      await remoteDataSource.updateProgress(lessonId);

      return const Right(null);
    } catch (e) {
      return Left(
        Failure(e.toString()),
      );
    }
  }
}
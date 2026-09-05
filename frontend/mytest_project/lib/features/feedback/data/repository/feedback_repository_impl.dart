import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/feedback.dart';
import '../../domain/repository/feedback_repository.dart';
import '../datasources/feedback_remote_data_source.dart';

class FeedbackRepositoryImpl
    implements FeedbackRepository {
  final FeedbackRemoteDataSource remoteDataSource;

  FeedbackRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Feedback>>> getFeedback() async {
    try {
      final feedback =
          await remoteDataSource.getFeedback();

      return Right(feedback);
    } on ServerException catch (e) {
      return Left(
        Failure(e.message),
      );
    } catch (e) {
      return Left(
        Failure(
          'Unable to load feedback: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Feedback>> submitFeedback({
    required String category,
    required String subject,
    required String message,
  }) async {
    try {
      final feedback =
          await remoteDataSource.submitFeedback(
        category: category,
        subject: subject,
        message: message,
      );

      return Right(feedback);
    } on ServerException catch (e) {
      return Left(
        Failure(e.message),
      );
    } catch (e) {
      return Left(
        Failure(
          'Unable to submit feedback: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Feedback>> getFeedbackById(
    int feedbackId,
  ) async {
    try {
      final feedback =
          await remoteDataSource.getFeedbackById(
        feedbackId,
      );

      return Right(feedback);
    } on ServerException catch (e) {
      return Left(
        Failure(e.message),
      );
    } catch (e) {
      return Left(
        Failure(
          'Unable to load feedback: $e',
        ),
      );
    }
  }
}
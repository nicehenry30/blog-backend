import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/feedback.dart';

abstract interface class FeedbackRepository {
  Future<Either<Failure, List<Feedback>>> getFeedback();

  Future<Either<Failure, Feedback>> submitFeedback({
    required String category,
    required String subject,
    required String message,
  });

  Future<Either<Failure, Feedback>> getFeedbackById(
    int feedbackId,
  );
}
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/feedback.dart';
import '../repository/feedback_repository.dart';

class GetFeedbackById {
  final FeedbackRepository repository;

  GetFeedbackById(this.repository);

  Future<Either<Failure, Feedback>> call(
    int feedbackId,
  ) {
    return repository.getFeedbackById(feedbackId);
  }
}
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/feedback.dart';
import '../repository/feedback_repository.dart';

class SubmitFeedback {
  final FeedbackRepository repository;

  SubmitFeedback(this.repository);

  Future<Either<Failure, Feedback>> call({
    required String category,
    required String subject,
    required String message,
  }) {
    return repository.submitFeedback(
      category: category,
      subject: subject,
      message: message,
    );
  }
}
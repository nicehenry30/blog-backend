import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/feedback.dart';
import '../repository/feedback_repository.dart';

class GetFeedback {
  final FeedbackRepository repository;

  GetFeedback(this.repository);

  Future<Either<Failure, List<Feedback>>> call() {
    return repository.getFeedback();
  }
}

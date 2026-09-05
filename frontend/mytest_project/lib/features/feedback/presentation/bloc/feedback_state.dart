part of 'feedback_bloc.dart';

sealed class FeedbackState {
  const FeedbackState();
}

final class FeedbackInitial extends FeedbackState {
  const FeedbackInitial();
}

final class FeedbackLoading extends FeedbackState {
  const FeedbackLoading();
}

final class FeedbackSubmitting extends FeedbackState {
  const FeedbackSubmitting();
}

final class FeedbackLoaded extends FeedbackState {
  final List<Feedback> feedback;

  const FeedbackLoaded(this.feedback);
}

final class FeedbackSubmitted extends FeedbackState {
  final Feedback feedback;

  const FeedbackSubmitted(this.feedback);
}

final class FeedbackDetailsLoaded extends FeedbackState {
  final Feedback feedback;

  const FeedbackDetailsLoaded(this.feedback);
}

final class FeedbackFailure extends FeedbackState {
  final String message;

  const FeedbackFailure(this.message);
}
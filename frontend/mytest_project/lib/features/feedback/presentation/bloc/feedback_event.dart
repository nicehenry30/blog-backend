part of 'feedback_bloc.dart';

sealed class FeedbackEvent {
  const FeedbackEvent();
}

final class LoadFeedback extends FeedbackEvent {
  const LoadFeedback();
}

final class SubmitUserFeedback extends FeedbackEvent {
  final String category;
  final String subject;
  final String message;

  const SubmitUserFeedback({
    required this.category,
    required this.subject,
    required this.message,
  });
}

final class LoadFeedbackDetails extends FeedbackEvent {
  final int feedbackId;

  const LoadFeedbackDetails(this.feedbackId);
}
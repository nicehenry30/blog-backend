import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/feedback.dart';
import '../../domain/usecases/get_feedback.dart';
import '../../domain/usecases/get_feedback_by_id.dart';
import '../../domain/usecases/submit_feedback.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final GetFeedback _getFeedback;
  final SubmitFeedback _submitFeedback;
  final GetFeedbackById _getFeedbackById;

  FeedbackBloc({
    required GetFeedback getFeedback,
    required SubmitFeedback submitFeedback,
    required GetFeedbackById getFeedbackById,
  })  : _getFeedback = getFeedback,
        _submitFeedback = submitFeedback,
        _getFeedbackById = getFeedbackById,
        super(const FeedbackInitial()) {
    on<LoadFeedback>(_onLoadFeedback);
    on<SubmitUserFeedback>(_onSubmitUserFeedback);
    on<LoadFeedbackDetails>(_onLoadFeedbackDetails);
  }

  Future<void> _onLoadFeedback(
    LoadFeedback event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(const FeedbackLoading());

    final result = await _getFeedback();

    result.fold(
      (failure) {
        emit(FeedbackFailure(failure.message));
      },
      (feedback) {
        emit(FeedbackLoaded(feedback));
      },
    );
  }

  Future<void> _onSubmitUserFeedback(
    SubmitUserFeedback event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(const FeedbackSubmitting());

    final result = await _submitFeedback(
      category: event.category,
      subject: event.subject,
      message: event.message,
    );

    result.fold(
      (failure) {
        emit(FeedbackFailure(failure.message));
      },
      (feedback) {
        emit(FeedbackSubmitted(feedback));
      },
    );
  }

  Future<void> _onLoadFeedbackDetails(
    LoadFeedbackDetails event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(const FeedbackLoading());

    final result = await _getFeedbackById(
      event.feedbackId,
    );

    result.fold(
      (failure) {
        emit(FeedbackFailure(failure.message));
      },
      (feedback) {
        emit(FeedbackDetailsLoaded(feedback));
      },
    );
  }
}
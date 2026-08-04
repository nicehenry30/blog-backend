part of 'journal_bloc.dart';

sealed class JournalState {
  const JournalState();
}

final class JournalInitial extends JournalState {
  const JournalInitial();
}

final class JournalLoading extends JournalState {
  const JournalLoading();
}

final class JournalLoaded extends JournalState {
  final List<Trade> trades;

  const JournalLoaded(this.trades);
}

final class JournalFailure extends JournalState {
  final String message;

  const JournalFailure(this.message);
}
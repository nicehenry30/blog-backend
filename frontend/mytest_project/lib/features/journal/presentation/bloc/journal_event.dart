part of 'journal_bloc.dart';

abstract class JournalEvent {
  const JournalEvent();
}

class JournalLoadTrades extends JournalEvent {
  const JournalLoadTrades();
}

class JournalAddTrade extends JournalEvent {
  final Trade trade;

  const JournalAddTrade(this.trade);
}

class JournalUpdateTrade extends JournalEvent {
  final Trade trade;

  const JournalUpdateTrade(this.trade);
}

class JournalDeleteTrade extends JournalEvent {
  final int tradeId;

  const JournalDeleteTrade(this.tradeId);
}
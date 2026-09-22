import '../../../../domain/models/transaction_entry.dart';

enum HistoryFilter { all, credit, debit }

abstract class HistoryEvent {
  const HistoryEvent();
}

class HistoryStarted extends HistoryEvent {
  const HistoryStarted();
}

class HistoryFilterChanged extends HistoryEvent {
  const HistoryFilterChanged(this.filter);

  final HistoryFilter filter;
}

class HistoryDeleteRequested extends HistoryEvent {
  const HistoryDeleteRequested(this.id);

  final int id;
}

class HistoryEntriesUpdated extends HistoryEvent {
  const HistoryEntriesUpdated(this.entries);

  final List<TransactionEntry> entries;
}

class HistoryQueryChanged extends HistoryEvent {
  const HistoryQueryChanged(this.query);

  final String query;
}

class HistoryMonthChanged extends HistoryEvent {
  const HistoryMonthChanged(this.month);

  final DateTime month;
}

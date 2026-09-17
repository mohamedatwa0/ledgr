import '../../../../domain/models/transaction_entry.dart';
import 'history_event.dart';

class HistoryState {
  const HistoryState({
    required this.filter,
    required this.entries,
    this.loading = false,
  });

  final HistoryFilter filter;
  final List<TransactionEntry> entries;
  final bool loading;

  static const initial = HistoryState(
    filter: HistoryFilter.all,
    entries: [],
    loading: true,
  );

  HistoryState copyWith({
    HistoryFilter? filter,
    List<TransactionEntry>? entries,
    bool? loading,
  }) {
    return HistoryState(
      filter: filter ?? this.filter,
      entries: entries ?? this.entries,
      loading: loading ?? this.loading,
    );
  }
}

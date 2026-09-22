import '../../../../domain/models/transaction_entry.dart';
import 'history_event.dart';

class HistoryState {
  const HistoryState({
    required this.filter,
    required this.entries,
    this.query = '',
    this.loading = false,
  });

  final HistoryFilter filter;
  final List<TransactionEntry> entries;
  final String query;
  final bool loading;

  List<TransactionEntry> get visibleEntries {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return entries;
    return entries.where((entry) {
      final note = entry.transaction.note?.toLowerCase() ?? '';
      final category = entry.category.name.toLowerCase();
      final amount = (entry.transaction.amount / 100).toStringAsFixed(2);
      return category.contains(q) || note.contains(q) || amount.contains(q);
    }).toList();
  }

  static const initial = HistoryState(
    filter: HistoryFilter.all,
    entries: [],
    loading: true,
  );

  HistoryState copyWith({
    HistoryFilter? filter,
    List<TransactionEntry>? entries,
    String? query,
    bool? loading,
  }) {
    return HistoryState(
      filter: filter ?? this.filter,
      entries: entries ?? this.entries,
      query: query ?? this.query,
      loading: loading ?? this.loading,
    );
  }
}

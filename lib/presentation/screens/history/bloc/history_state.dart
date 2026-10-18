import '../../../../domain/date_utils.dart';
import '../../../../domain/models/transaction_entry.dart';
import '../../../formatters/category_labels.dart';
import '../../../formatters/money_format.dart';
import '../../../../l10n/app_localizations.dart';
import 'history_event.dart';

class HistoryState {
  const HistoryState({
    required this.filter,
    required this.entries,
    required this.month,
    this.query = '',
    this.loading = false,
    this.undoEntry,
    this.errorMessage,
  });

  final HistoryFilter filter;
  final List<TransactionEntry> entries;
  final DateTime month;
  final String query;
  final bool loading;
  final TransactionEntry? undoEntry;
  final String? errorMessage;

  bool get isCurrentMonth => isSameMonth(month, DateTime.now());

  List<TransactionEntry> visibleFor(AppLocalizations l10n) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return entries;
    final qDigits = easternQuery(q);
    return entries.where((entry) {
      final note = entry.transaction.note?.toLowerCase() ?? '';
      final stored = entry.category.name.toLowerCase();
      final localized =
          localizedCategoryName(l10n, entry.category.name).toLowerCase();
      final amount = formatSubtotal(entry.transaction.amount);
      final compact = amount.replaceAll(',', '');
      return stored.contains(q) ||
          localized.contains(q) ||
          note.contains(q) ||
          amount.contains(q) ||
          compact.contains(qDigits);
    }).toList();
  }

  factory HistoryState.initial() {
    return HistoryState(
      filter: HistoryFilter.all,
      entries: const [],
      month: monthStart(DateTime.now()),
      loading: true,
    );
  }

  HistoryState copyWith({
    HistoryFilter? filter,
    List<TransactionEntry>? entries,
    DateTime? month,
    String? query,
    bool? loading,
    TransactionEntry? undoEntry,
    String? errorMessage,
    bool clearUndo = false,
    bool clearError = false,
  }) {
    return HistoryState(
      filter: filter ?? this.filter,
      entries: entries ?? this.entries,
      month: month ?? this.month,
      query: query ?? this.query,
      loading: loading ?? this.loading,
      undoEntry: clearUndo ? null : (undoEntry ?? this.undoEntry),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

String easternQuery(String query) {
  return query.replaceAll(',', '').replaceAll('٬', '');
}

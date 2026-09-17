import '../../../../domain/date_utils.dart';
import '../../../../domain/models/monthly_summary.dart';
import '../../../../domain/models/transaction_entry.dart';

class HomeState {
  const HomeState({
    required this.month,
    required this.entries,
    required this.summary,
    required this.currencyCode,
    this.loading = false,
  });

  final DateTime month;
  final List<TransactionEntry> entries;
  final MonthlySummary summary;
  final String currencyCode;
  final bool loading;

  factory HomeState.initial() {
    return HomeState(
      month: monthStart(DateTime.now()),
      entries: const [],
      summary: MonthlySummary.empty,
      currencyCode: 'EGP',
      loading: true,
    );
  }

  bool get isCurrentMonth => isSameMonth(month, DateTime.now());

  HomeState copyWith({
    DateTime? month,
    List<TransactionEntry>? entries,
    MonthlySummary? summary,
    String? currencyCode,
    bool? loading,
  }) {
    return HomeState(
      month: month ?? this.month,
      entries: entries ?? this.entries,
      summary: summary ?? this.summary,
      currencyCode: currencyCode ?? this.currencyCode,
      loading: loading ?? this.loading,
    );
  }
}

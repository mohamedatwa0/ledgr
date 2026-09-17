import '../../../../domain/models/transaction_entry.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class HomeStarted extends HomeEvent {
  const HomeStarted();
}

class HomeMonthChanged extends HomeEvent {
  const HomeMonthChanged(this.month);

  final DateTime month;
}

class HomeEntriesUpdated extends HomeEvent {
  const HomeEntriesUpdated(this.entries);

  final List<TransactionEntry> entries;
}

class HomeCurrencyUpdated extends HomeEvent {
  const HomeCurrencyUpdated(this.currencyCode);

  final String currencyCode;
}

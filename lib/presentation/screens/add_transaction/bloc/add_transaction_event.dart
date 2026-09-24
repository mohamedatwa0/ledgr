import '../../../../domain/models/category.dart';
import '../../../../domain/models/transaction_type.dart';

abstract class AddTransactionEvent {
  const AddTransactionEvent();
}

class AddTransactionStarted extends AddTransactionEvent {
  const AddTransactionStarted();
}

class AddTransactionAmountChanged extends AddTransactionEvent {
  const AddTransactionAmountChanged(this.value);

  final String value;
}

class AddTransactionTypeChanged extends AddTransactionEvent {
  const AddTransactionTypeChanged(this.type);

  final TransactionType type;
}

class AddTransactionCategorySelected extends AddTransactionEvent {
  const AddTransactionCategorySelected(this.categoryId);

  final int categoryId;
}

class AddTransactionPendingCategorySelected extends AddTransactionEvent {
  const AddTransactionPendingCategorySelected();
}

class AddTransactionNoteChanged extends AddTransactionEvent {
  const AddTransactionNoteChanged(this.note);

  final String note;
}

class AddTransactionDateChanged extends AddTransactionEvent {
  const AddTransactionDateChanged(this.date);

  final DateTime date;
}

class AddTransactionSaveRequested extends AddTransactionEvent {
  const AddTransactionSaveRequested();
}

class AddTransactionDeleteRequested extends AddTransactionEvent {
  const AddTransactionDeleteRequested();
}

class AddTransactionCategoriesUpdated extends AddTransactionEvent {
  const AddTransactionCategoriesUpdated(this.categories);

  final List<Category> categories;
}

class AddTransactionCurrencyUpdated extends AddTransactionEvent {
  const AddTransactionCurrencyUpdated(this.currencyCode);

  final String currencyCode;
}

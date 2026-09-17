import '../../../../domain/models/category.dart';
import '../../../../domain/models/transaction_type.dart';

abstract class SmsReviewEvent {
  const SmsReviewEvent();
}

class SmsReviewStarted extends SmsReviewEvent {
  const SmsReviewStarted();
}

class SmsReviewAmountChanged extends SmsReviewEvent {
  const SmsReviewAmountChanged(this.value);

  final String value;
}

class SmsReviewTypeChanged extends SmsReviewEvent {
  const SmsReviewTypeChanged(this.type);

  final TransactionType type;
}

class SmsReviewCategorySelected extends SmsReviewEvent {
  const SmsReviewCategorySelected(this.categoryId);

  final int categoryId;
}

class SmsReviewNoteChanged extends SmsReviewEvent {
  const SmsReviewNoteChanged(this.note);

  final String note;
}

class SmsReviewDateChanged extends SmsReviewEvent {
  const SmsReviewDateChanged(this.date);

  final DateTime date;
}

class SmsReviewSaveRequested extends SmsReviewEvent {
  const SmsReviewSaveRequested();
}

class SmsReviewDismissRequested extends SmsReviewEvent {
  const SmsReviewDismissRequested();
}

class SmsReviewCategoriesUpdated extends SmsReviewEvent {
  const SmsReviewCategoriesUpdated(this.categories);

  final List<Category> categories;
}

class SmsReviewCurrencyUpdated extends SmsReviewEvent {
  const SmsReviewCurrencyUpdated(this.currencyCode);

  final String currencyCode;
}

import '../../domain/models/app_settings.dart';
import '../../domain/models/category.dart';
import '../../domain/models/ledger_transaction.dart';
import '../../domain/models/transaction_entry.dart';
import '../../domain/sms/sms_inbox_item.dart';
import 'db/app_database.dart';

Category categoryFromRow(CategoryRow row) {
  return Category(
    id: row.id,
    name: row.name,
    type: row.type,
    iconCodePoint: row.iconCodePoint,
    colorValue: row.colorValue,
    isDefault: row.isDefault,
    isFallback: row.isFallback,
  );
}

LedgerTransaction transactionFromRow(TransactionRow row) {
  return LedgerTransaction(
    id: row.id,
    amount: row.amount,
    type: row.type,
    categoryId: row.categoryId,
    note: row.note,
    date: row.date,
    createdAt: row.createdAt,
    source: row.source,
  );
}

TransactionEntry entryFromRows(TransactionRow transaction, CategoryRow category) {
  return TransactionEntry(
    transaction: transactionFromRow(transaction),
    category: categoryFromRow(category),
  );
}

AppSettings settingsFromRow(SettingsRow row) {
  return AppSettings(
    currencyCode: row.currencyCode,
    smsLastScanAt: row.smsLastScanAt,
    themeMode: row.themeMode,
    defaultEntryType: row.defaultEntryType,
    locale: row.localeCode,
  );
}

SmsInboxItem smsInboxFromRow(SmsInboxRow row) {
  return SmsInboxItem(
    id: row.id,
    fingerprint: row.fingerprint,
    platformMessageId: row.platformMessageId,
    sender: row.sender,
    body: row.body,
    receivedAt: row.receivedAt,
    createdAt: row.createdAt,
    status: row.status,
    bankId: row.bankId,
    templateId: row.templateId,
    amount: row.amount,
    type: row.type,
    suggestedCategoryId: row.suggestedCategoryId,
    note: row.note,
    valueDate: row.valueDate,
    currencyCode: row.currencyCode,
    transactionId: row.transactionId,
  );
}

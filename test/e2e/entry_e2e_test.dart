import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ledgr/data/db/app_database.dart';
import 'package:ledgr/domain/date_utils.dart';
import 'package:ledgr/domain/models/transaction_type.dart';
import 'package:ledgr/presentation/screens/add_transaction/bloc/add_transaction_state.dart';

import '../support/ledgr_harness.dart';

AddTransactionState _state({
  String amountText = '',
  bool saved = false,
  String? errorMessage,
}) {
  return AddTransactionState(
    amountText: amountText,
    type: TransactionType.expense,
    note: '',
    date: dateOnly(DateTime.now()),
    currencyCode: 'EGP',
    categories: const [],
    saved: saved,
    errorMessage: errorMessage,
  );
}

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('copyWith clears saved and error unless set again', () {
    final saved = _state().copyWith(saved: true, errorMessage: 'boom');
    expect(saved.saved, isTrue);
    expect(saved.errorMessage, 'boom');
    final next = saved.copyWith(amountText: '1');
    expect(next.saved, isFalse);
    expect(next.errorMessage, isNull);
  });

  testWidgets('duplicate category snackbar shows once', (tester) async {
    await pumpApp(tester, db: db);
    await tester.tap(find.byKey(const Key('add-transaction-fab')));
    await settle(tester);
    final addCategory = find.byKey(const Key('add-new-category'));
    await tester.ensureVisible(addCategory);
    await tester.drag(find.byType(ListView), const Offset(0, -180));
    await tester.pumpAndSettle();
    await tester.tap(addCategory);
    await settle(tester);

    await tester.enterText(
      find.byKey(const Key('category-name-field')),
      'Food & Dining',
    );
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    await tester.ensureVisible(find.byKey(const Key('save-category')));
    await tester.tap(find.byKey(const Key('save-category')));
    await settle(tester);

    expect(
      find.text('A category with that name already exists.'),
      findsOneWidget,
    );

    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    expect(
      find.text('A category with that name already exists.'),
      findsNothing,
    );

    await tester.enterText(
      find.byKey(const Key('category-name-field')),
      'Food & Dining ',
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(
      find.text('A category with that name already exists.'),
      findsNothing,
    );
    await disposeApp(tester);
  });

  testWidgets('missing transaction shows an error not a spinner', (tester) async {
    await pumpApp(tester, db: db);
    await pushRoute(tester, '/transaction/999');

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('This entry is no longer in the ledger.'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('saving an entry returns to the dashboard once', (tester) async {
    await pumpApp(tester, db: db);
    await tester.tap(find.byKey(const Key('add-transaction-fab')));
    await settle(tester);
    await tester.enterText(find.byKey(const Key('amount-field')), '45');
    await tester.tap(find.byKey(const Key('category-Food & Dining')));
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    await tester.tap(find.byKey(const Key('save-entry')));
    await settle(tester);

    expect(find.byKey(const Key('add-transaction-fab')), findsOneWidget);
    expect(find.text('Food & Dining'), findsWidgets);
    expect(find.byKey(const Key('save-entry')), findsNothing);
    await disposeApp(tester);
  });

  testWidgets('edit screen deletes the open entry', (tester) async {
    final created = await insertTransaction(db, amount: 4500, note: 'To delete');
    await pumpApp(tester, db: db);

    await pushRoute(tester, '/transaction/${created.id}');
    await tester.tap(find.byKey(const Key('delete-entry')));
    await settle(tester);
    expect(find.text('Delete entry'), findsOneWidget);
    await tester.tap(find.text('Delete'));
    await settle(tester);

    await tester.tap(find.byKey(const Key('tab-transactions')));
    await settle(tester);
    expect(find.text('To delete'), findsNothing);
    expect(find.text('No transactions in this view'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('back with a typed amount asks before discarding', (tester) async {
    await pumpApp(tester, db: db);
    await tester.tap(find.byKey(const Key('add-transaction-fab')));
    await settle(tester);
    await tester.enterText(find.byKey(const Key('amount-field')), '45');
    await tester.pump();

    await tester.tap(find.byTooltip('Back'));
    await settle(tester);

    expect(find.text('Discard this entry?'), findsOneWidget);
    await tester.tap(find.text('Discard'));
    await settle(tester);

    expect(find.byKey(const Key('add-transaction-fab')), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('keypad is on screen with the amount field', (tester) async {
    await pumpApp(tester, db: db);
    await tester.tap(find.byKey(const Key('add-transaction-fab')));
    await settle(tester);

    expect(find.byKey(const Key('amount-field')), findsOneWidget);
    expect(find.text('1'), findsWidgets);
    expect(find.text('0'), findsWidgets);
    await disposeApp(tester);
  });

  testWidgets('duplicate category is localized in Arabic', (tester) async {
    await pumpApp(tester, db: db);
    await tester.tap(find.byKey(const Key('tab-settings')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('settings-locale-ar')));
    await settle(tester);

    await tester.tap(find.byKey(const Key('tab-dashboard')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('add-transaction-fab')));
    await settle(tester);
    final addCategory = find.byKey(const Key('add-new-category'));
    await tester.ensureVisible(addCategory);
    await tester.drag(find.byType(ListView), const Offset(0, -180));
    await tester.pumpAndSettle();
    await tester.tap(addCategory);
    await settle(tester);

    await tester.enterText(
      find.byKey(const Key('category-name-field')),
      'Food & Dining',
    );
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    await tester.ensureVisible(find.byKey(const Key('save-category')));
    await tester.tap(find.byKey(const Key('save-category')));
    await settle(tester);

    expect(find.text('يوجد تصنيف بهذا الاسم بالفعل.'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('amount field accepts Arabic-Indic digits', (tester) async {
    await pumpApp(tester, db: db);
    await tester.tap(find.byKey(const Key('add-transaction-fab')));
    await settle(tester);

    await tester.enterText(find.byKey(const Key('amount-field')), '٤٥');
    await tester.pump();

    final field = tester.widget<TextField>(find.byKey(const Key('amount-field')));
    expect(field.controller?.text, '45');
    await disposeApp(tester);
  });
}

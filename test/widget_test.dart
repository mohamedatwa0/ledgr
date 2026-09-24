import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ledgr/data/db/app_database.dart';

import 'support/ledgr_harness.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('adding a transaction shows it on the home ledger',
      (tester) async {
    await pumpApp(tester, db: db);

    await openNewEntry(tester);

    await tester.enterText(find.byKey(const Key('amount-field')), '45');
    await tester.tap(find.byKey(const Key('category-Food & Dining')));
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();

    await tester.tap(find.byKey(const Key('save-entry')));
    await settle(tester);

    expect(find.text('Food & Dining'), findsWidgets);
    expect(find.text('-45.00'), findsWidgets);
    expect(find.byKey(const Key('month-debits')), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(const Key('month-debits'))).data,
      '-45.00',
    );
    await disposeApp(tester);
  });

  testWidgets('swiping an entry on the dashboard deletes it', (tester) async {
    await pumpApp(tester, db: db);

    await openNewEntry(tester);
    await tester.enterText(find.byKey(const Key('amount-field')), '45');
    await tester.tap(find.byKey(const Key('category-Food & Dining')));
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    await tester.tap(find.byKey(const Key('save-entry')));
    await settle(tester);

    final entry = find.byType(Dismissible);
    await tester.ensureVisible(entry);
    await tester.drag(entry, const Offset(-500, 0));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Delete entry'), findsOneWidget);
    await tester.tap(find.text('Delete'));
    await settle(tester);

    expect(
      find.text('No transactions yet — tap + to add your first one'),
      findsOneWidget,
    );
    await disposeApp(tester);
  });

  testWidgets('deleting a transaction removes it from history', (tester) async {
    await pumpApp(tester, db: db);

    await openNewEntry(tester);
    await tester.enterText(find.byKey(const Key('amount-field')), '45');
    await tester.tap(find.byKey(const Key('category-Food & Dining')));
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    await tester.tap(find.byKey(const Key('save-entry')));
    await settle(tester);

    await tester.tap(find.byKey(const Key('tab-transactions')));
    await settle(tester);

    expect(find.byType(Dismissible), findsOneWidget);

    await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Delete entry'), findsOneWidget);
    await tester.tap(find.text('Delete'));
    await settle(tester);

    expect(find.byType(Dismissible), findsNothing);
    expect(find.text('No transactions in this view'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('adding a custom category shows it on a new entry', (
    tester,
  ) async {
    await pumpApp(tester, db: db);

    await openNewEntry(tester);
    final addCategory = find.byKey(const Key('add-new-category'));
    await tester.ensureVisible(addCategory);
    await tester.drag(find.byType(ListView), const Offset(0, -180));
    await tester.pumpAndSettle();
    await tester.tap(addCategory);
    await settle(tester);

    await tester.enterText(
        find.byKey(const Key('category-name-field')), 'Pets');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    await tester.ensureVisible(find.byKey(const Key('save-category')));
    await tester.tap(find.byKey(const Key('save-category')));
    await settle(tester);

    expect(find.text('Pets'), findsWidgets);
    await disposeApp(tester);
  });

  testWidgets('pasting a bank SMS shows it in To review', (tester) async {
    await pumpApp(tester, db: db);
    await openSmsAndParse(tester);

    expect(find.text('STARBUCKS'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('confirming a parsed SMS adds it to the home ledger', (
    tester,
  ) async {
    await pumpApp(tester, db: db);
    await openSmsAndParse(tester);

    await tester.ensureVisible(find.text('STARBUCKS'));
    await tester.tap(find.text('STARBUCKS'));
    await settle(tester);
    await tester.tap(find.byKey(const Key('save-entry')));
    await settle(tester);

    await tester.tap(find.byTooltip('Back'));
    await settle(tester);
    await tester.tap(find.byKey(const Key('tab-dashboard')));
    await settle(tester);

    expect(find.text('Food & Dining'), findsOneWidget);
    expect(find.text('-250.00'), findsWidgets);
    await disposeApp(tester);
  });

  testWidgets('dismissing a parsed SMS does not add it to the home ledger', (
    tester,
  ) async {
    await pumpApp(tester, db: db);
    await openSmsAndParse(tester);

    await tester.ensureVisible(find.text('STARBUCKS'));
    await tester.tap(find.text('STARBUCKS'));
    await settle(tester);
    await tester.tap(find.byKey(const Key('sms-dismiss')));
    await settle(tester);
    expect(find.text('Skip this SMS?'), findsOneWidget);
    await tester.tap(find.text('Skip'));
    await settle(tester);

    await tester.tap(find.byTooltip('Back'));
    await settle(tester);
    await tester.tap(find.byKey(const Key('tab-dashboard')));
    await settle(tester);

    expect(find.text('-250.00'), findsNothing);
    await disposeApp(tester);
  });

  testWidgets('duplicate paste does not create a second ready row', (
    tester,
  ) async {
    await pumpApp(tester, db: db);
    await openSmsAndParse(tester);

    await tester.enterText(find.byKey(const Key('sms-paste-field')), cibSms);
    await tester.pump();
    await tester.ensureVisible(find.byKey(const Key('sms-parse-button')));
    await tester.tap(find.byKey(const Key('sms-parse-button')));
    await settle(tester);

    expect(find.text('STARBUCKS'), findsOneWidget);
    expect(find.text('Already in the inbox'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('switching language to Arabic applies RTL', (tester) async {
    await pumpApp(tester, db: db);

    await tester.tap(find.byKey(const Key('tab-settings')));
    await settle(tester);

    await tester.tap(find.byKey(const Key('settings-locale-ar')));
    await settle(tester);

    expect(find.text('اللغة'), findsWidgets);
    expect(
      Directionality.of(
          tester.element(find.byKey(const Key('settings-locale')))),
      TextDirection.rtl,
    );
    await disposeApp(tester);
  });
}

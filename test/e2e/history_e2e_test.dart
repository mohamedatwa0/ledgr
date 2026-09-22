import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:ledgr/data/db/app_database.dart';
import 'package:ledgr/domain/date_utils.dart';

import '../support/ledgr_harness.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('history pages by month', (tester) async {
    final today = dateOnly(DateTime.now());
    final lastMonth = DateTime(today.year, today.month - 1, 10);
    await insertTransaction(
      db,
      amount: 4500,
      date: today,
      note: 'This month coffee',
    );
    await insertTransaction(
      db,
      amount: 12000,
      date: lastMonth,
      note: 'Last month rent',
    );

    await pumpApp(tester, db: db);
    await tester.tap(find.byKey(const Key('tab-transactions')));
    await settle(tester);

    expect(find.text('This month coffee'), findsOneWidget);
    expect(find.text('Last month rent'), findsNothing);
    expect(
      find.text(DateFormat('MMMM y').format(today)),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('history-previous-month')));
    await settle(tester);

    expect(find.text('Last month rent'), findsOneWidget);
    expect(find.text('This month coffee'), findsNothing);
    expect(
      find.text(DateFormat('MMMM y').format(lastMonth)),
      findsOneWidget,
    );
    await disposeApp(tester);
  });

  testWidgets('arabic category label matches history search', (tester) async {
    await insertTransaction(db, amount: 4500, note: 'Cafe');
    await pumpApp(tester, db: db);

    await tester.tap(find.byKey(const Key('tab-settings')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('settings-locale-ar')));
    await settle(tester);

    await tester.tap(find.byKey(const Key('tab-transactions')));
    await settle(tester);

    await tester.enterText(find.byKey(const Key('history-search')), 'طعام');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Cafe'), findsOneWidget);
    await disposeApp(tester);
  });
}

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ledgr/app.dart';
import 'package:ledgr/data/db/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(LedgrApp(database: db));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  Future<void> disposeApp(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  }

  testWidgets('adding a transaction shows it on the home ledger', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byKey(const Key('add-transaction-fab')));
    await settle(tester);

    await tester.enterText(find.byKey(const Key('amount-field')), '45');
    await tester.tap(find.byKey(const Key('category-Food & Dining')));
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();

    await tester.tap(find.byKey(const Key('save-entry')));
    await settle(tester);

    expect(find.text('Food & Dining'), findsOneWidget);
    expect(find.text('-45.00'), findsOneWidget);
    expect(find.textContaining('Debits 45.00'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('deleting a transaction removes it from history', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byKey(const Key('add-transaction-fab')));
    await settle(tester);
    await tester.enterText(find.byKey(const Key('amount-field')), '45');
    await tester.tap(find.byKey(const Key('category-Food & Dining')));
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    await tester.tap(find.byKey(const Key('save-entry')));
    await settle(tester);

    await tester.tap(find.byKey(const Key('see-all')));
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

  testWidgets('adding a custom category shows it in the category list', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.byKey(const Key('settings-button')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('settings-categories')));
    await settle(tester);

    await tester.tap(find.byKey(const Key('add-category-cell')));
    await settle(tester);

    await tester.enterText(find.byKey(const Key('category-name-field')), 'Pets');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    await tester.tap(find.byKey(const Key('save-category')));
    await settle(tester);

    expect(find.text('Pets'), findsWidgets);
    await disposeApp(tester);
  });
}

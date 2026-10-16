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

  testWidgets('add category button stays above the keyboard', (tester) async {
    await pumpApp(tester, db: db);
    await openNewEntry(tester);
    await _openNewCategory(tester);

    const keyboardHeight = 320.0;
    tester.view.viewInsets = const FakeViewPadding(bottom: keyboardHeight);
    addTearDown(tester.view.resetViewInsets);
    await tester.pump();

    final button = tester.getRect(find.byKey(const Key('save-category')));
    final keyboardTop = tester.view.physicalSize.height - keyboardHeight;
    expect(button.bottom, lessThanOrEqualTo(keyboardTop));
    expect(button.bottom, greaterThan(keyboardTop - 90));

    await disposeApp(tester);
  });

  testWidgets('holding a custom category edits and deletes it', (tester) async {
    await pumpApp(tester, db: db);
    await openNewEntry(tester);
    await _openNewCategory(tester);

    await tester.enterText(
        find.byKey(const Key('category-name-field')), 'Pets');
    await tester.pump();
    await tester.tap(find.byKey(const Key('save-category')));
    await settle(tester);

    expect(find.byKey(const Key('category-Pets')), findsOneWidget);
    await _reveal(tester, find.byKey(const Key('category-Pets')));
    await tester.longPress(find.byKey(const Key('category-Pets')));
    await settle(tester);

    expect(find.text('Edit Category'), findsOneWidget);
    expect(find.byKey(const Key('delete-category')), findsOneWidget);
    await tester.tap(find.byKey(const Key('delete-category')));
    await settle(tester);
    await tester.tap(find.text('Delete'));
    await settle(tester);

    expect(find.byKey(const Key('category-Pets')), findsNothing);
    await disposeApp(tester);
  });

  testWidgets('holding a default category explains it is protected',
      (tester) async {
    await pumpApp(tester, db: db);
    await openNewEntry(tester);
    await tester.ensureVisible(find.byKey(const Key('category-Food & Dining')));
    await tester.longPress(find.byKey(const Key('category-Food & Dining')));
    await settle(tester);

    expect(
      find.text('Default categories cannot be changed or deleted.'),
      findsOneWidget,
    );
    expect(find.text('Edit Category'), findsNothing);
    await disposeApp(tester);
  });
}

Future<void> _openNewCategory(WidgetTester tester) async {
  final finder = find.byKey(const Key('add-new-category'));
  await _reveal(tester, finder);
  await tester.tap(finder);
  await settle(tester);
}

Future<void> _reveal(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pump();
  final scrollable = find.ancestor(
    of: finder,
    matching: find.byType(Scrollable),
  );
  await tester.drag(scrollable.first, const Offset(0, -180));
  await tester.pump();
}

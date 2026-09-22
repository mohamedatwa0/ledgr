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
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      LedgrApp(database: db, showLaunchScreen: false),
    );
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

    expect(find.text('Food & Dining'), findsWidgets);
    expect(find.text('-45.00'), findsWidgets);
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

  testWidgets('adding a custom category shows it in the category list', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.byKey(const Key('tab-categories')));
    await settle(tester);

    await tester.tap(find.byKey(const Key('add-category-cell')));
    await settle(tester);

    await tester.enterText(find.byKey(const Key('category-name-field')), 'Pets');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    await tester.ensureVisible(find.byKey(const Key('save-category')));
    await tester.tap(find.byKey(const Key('save-category')));
    await settle(tester);

    expect(find.text('Pets'), findsWidgets);
    await disposeApp(tester);
  });

  const cibSms =
      'CIB: Purchase of EGP 250.00 at STARBUCKS using card ending 1234 '
      'on 15/09/2026. Available balance EGP 5,000.00';

  Future<void> openSmsAndParse(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('tab-settings')));
    await settle(tester);
    expect(find.text('Language'), findsOneWidget);
    await tester.dragUntilVisible(
      find.byKey(const Key('settings-sms')),
      find.byType(ListView),
      const Offset(0, -200),
    );
    await tester.tap(find.byKey(const Key('settings-sms')));
    await settle(tester);
    await tester.enterText(find.byKey(const Key('sms-paste-field')), cibSms);
    await tester.pump();
    await tester.ensureVisible(find.byKey(const Key('sms-parse-button')));
    await tester.tap(find.byKey(const Key('sms-parse-button')));
    await settle(tester);
  }

  testWidgets('pasting a bank SMS shows it in To review', (tester) async {
    await pumpApp(tester);
    await openSmsAndParse(tester);

    expect(find.text('STARBUCKS'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('confirming a parsed SMS adds it to the home ledger', (
    tester,
  ) async {
    await pumpApp(tester);
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
    await pumpApp(tester);
    await openSmsAndParse(tester);

    await tester.ensureVisible(find.text('STARBUCKS'));
    await tester.tap(find.text('STARBUCKS'));
    await settle(tester);
    await tester.tap(find.byKey(const Key('sms-dismiss')));
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
    await pumpApp(tester);
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
    await pumpApp(tester);

    await tester.tap(find.byKey(const Key('tab-settings')));
    await settle(tester);

    await tester.tap(find.byKey(const Key('settings-locale-ar')));
    await settle(tester);

    expect(find.text('اللغة'), findsWidgets);
    expect(
      Directionality.of(tester.element(find.byKey(const Key('settings-locale')))),
      TextDirection.rtl,
    );
    await disposeApp(tester);
  });
}

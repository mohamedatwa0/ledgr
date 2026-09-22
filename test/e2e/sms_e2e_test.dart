import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ledgr/data/db/app_database.dart';

import '../support/ledgr_harness.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('successful parse clears the paste field', (tester) async {
    await pumpApp(tester, db: db);
    await openSmsAndParse(tester);

    final field =
        tester.widget<TextField>(find.byKey(const Key('sms-paste-field')));
    expect(field.controller?.text, isEmpty);
    expect(find.text('STARBUCKS'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('imported rows cannot be swiped away', (tester) async {
    await pumpApp(tester, db: db);
    await openSmsAndParse(tester);

    await tester.ensureVisible(find.text('STARBUCKS'));
    await tester.tap(find.text('STARBUCKS'));
    await settle(tester);
    await tester.tap(find.byKey(const Key('save-entry')));
    await settle(tester);

    await tester.tap(find.text('Imported'));
    await settle(tester);

    expect(find.text('STARBUCKS'), findsOneWidget);
    expect(find.byType(Dismissible), findsNothing);
    await disposeApp(tester);
  });

  testWidgets('scan recovers when the gateway throws', (tester) async {
    await pumpApp(
      tester,
      db: db,
      smsGateway: const ThrowingScanGateway(),
    );
    await tester.tap(find.byKey(const Key('tab-settings')));
    await settle(tester);
    await tester.dragUntilVisible(
      find.byKey(const Key('settings-sms')),
      find.byType(ListView),
      const Offset(0, -200),
    );
    await tester.tap(find.byKey(const Key('settings-sms')));
    await settle(tester);

    expect(find.byKey(const Key('sms-scan-button')), findsOneWidget);
    await tester.tap(find.byKey(const Key('sms-scan-button')));
    await settle(tester);

    expect(find.text('Scanning…'), findsNothing);
    expect(find.text('Scan inbox'), findsOneWidget);
    await disposeApp(tester);
  });
}

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ledgr/data/db/app_database.dart';
import 'package:ledgr/domain/date_utils.dart';
import 'package:ledgr/domain/models/category.dart';
import 'package:ledgr/domain/models/ledger_transaction.dart';
import 'package:ledgr/domain/models/transaction_entry.dart';
import 'package:ledgr/domain/models/transaction_type.dart';
import 'package:ledgr/l10n/app_localizations.dart';
import 'package:ledgr/presentation/widgets/daily_outlay_ribbon.dart';
import 'package:ledgr/presentation/widgets/directional_icon.dart';
import 'package:ledgr/theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../support/ledgr_harness.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('a deficit month shows a minus on the hero amount', (tester) async {
    await insertTransaction(db, amount: 4500);
    await pumpApp(tester, db: db);

    expect(find.byKey(const Key('month-balance')), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(const Key('month-balance'))).data,
      '-45.00',
    );
    await disposeApp(tester);
  });

  testWidgets('previous month is not labeled this month', (tester) async {
    await pumpApp(tester, db: db);

    expect(find.text('THIS MONTH'), findsOneWidget);
    await tester.tap(find.byKey(const Key('previous-month')));
    await settle(tester);

    expect(find.text('THIS MONTH'), findsNothing);
    await disposeApp(tester);
  });

  testWidgets('ledger rows do not show midnight as a clock time', (tester) async {
    await insertTransaction(db, amount: 4500);
    await pumpApp(tester, db: db);

    expect(find.textContaining('12:00'), findsNothing);
    expect(find.textContaining('AM'), findsNothing);
    await disposeApp(tester);
  });

  testWidgets('month chevrons flip in Arabic', (tester) async {
    await pumpApp(tester, db: db);

    await tester.tap(find.byKey(const Key('tab-settings')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('settings-locale-ar')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('tab-dashboard')));
    await settle(tester);

    expect(
      Directionality.of(
        tester.element(find.byKey(const Key('previous-month'))),
      ),
      TextDirection.rtl,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('previous-month')),
        matching: find.byType(DirectionalIcon),
      ),
      findsOneWidget,
    );
    await disposeApp(tester);
  });

  testWidgets('daily outlay highlights today early in the month', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    final now = DateTime(2026, 9, 3);
    final category = const Category(
      id: 1,
      name: 'Food & Dining',
      type: TransactionType.expense,
      iconCodePoint: 1,
      colorValue: 0xFF1C2B3A,
      isDefault: true,
    );
    TransactionEntry entryOn(int day) {
      return TransactionEntry(
        transaction: LedgerTransaction(
          id: day,
          amount: 1000,
          type: TransactionType.expense,
          categoryId: 1,
          date: DateTime(2026, 9, day),
          createdAt: DateTime(2026, 9, day),
        ),
        category: category,
      );
    }

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => MaterialApp(
          theme: ledgrLightTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: DailyOutlayRibbon(
              entries: [entryOn(1), entryOn(2), entryOn(3)],
              month: monthStart(now),
              currencyCode: 'EGP',
              now: now,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(const Key('outlay-bar-highlight')), findsOneWidget);
    expect(find.byKey(const Key('outlay-bar-0')), findsOneWidget);
    expect(find.byKey(const Key('outlay-bar-1')), findsOneWidget);
    expect(find.byKey(const Key('outlay-bar-3')), findsNothing);
  });
}

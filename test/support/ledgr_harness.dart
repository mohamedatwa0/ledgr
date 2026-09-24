import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ledgr/app.dart';
import 'package:ledgr/data/db/app_database.dart';
import 'package:ledgr/data/repositories/category_repository_impl.dart';
import 'package:ledgr/data/repositories/transaction_repository_impl.dart';
import 'package:ledgr/domain/date_utils.dart';
import 'package:ledgr/domain/models/ledger_transaction.dart';
import 'package:ledgr/domain/models/transaction_type.dart';
import 'package:ledgr/domain/sms/sms_gateway.dart';
import 'package:ledgr/domain/sms/sms_message.dart';
import 'package:ledgr/presentation/widgets/ledgr_shell.dart';

const cibSms =
    'CIB: Purchase of EGP 250.00 at STARBUCKS using card ending 1234 '
    'on 15/09/2026. Available balance EGP 5,000.00';

Future<void> pumpApp(
  WidgetTester tester, {
  required AppDatabase db,
  SmsGateway? smsGateway,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(390, 844);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  await tester.binding.setSurfaceSize(const Size(390, 844));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    LedgrApp(
      database: db,
      smsGateway: smsGateway,
      showLaunchScreen: false,
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

Future<void> settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Future<void> openNewEntry(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('add-transaction-fab')));
  await settle(tester);
  await tester.tap(find.byKey(const Key('add-entry-manual')));
  await settle(tester);
}

Future<void> disposeApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 1));
}

Future<LedgerTransaction> insertTransaction(
  AppDatabase db, {
  String categoryName = 'Food & Dining',
  TransactionType type = TransactionType.expense,
  int amount = 4500,
  DateTime? date,
  String? note,
}) async {
  final categories = CategoryRepositoryImpl(db);
  final transactions = TransactionRepositoryImpl(db);
  final category = await categories.findByNameAndType(categoryName, type);
  return transactions.create(
    amount: amount,
    type: type,
    categoryId: category!.id,
    date: date ?? dateOnly(DateTime.now()),
    note: note,
  );
}

Future<void> pushRoute(WidgetTester tester, String location) async {
  final context = tester.element(find.byType(LedgrShell));
  GoRouter.of(context).push(location);
  await settle(tester);
}

Future<void> openSmsAndParse(
  WidgetTester tester, {
  String body = cibSms,
}) async {
  await tester.tap(find.byKey(const Key('tab-settings')));
  await settle(tester);
  await tester.dragUntilVisible(
    find.byKey(const Key('settings-sms')),
    find.byType(ListView),
    const Offset(0, -200),
  );
  await tester.tap(find.byKey(const Key('settings-sms')));
  await settle(tester);
  await tester.enterText(find.byKey(const Key('sms-paste-field')), body);
  await tester.pump();
  await tester.ensureVisible(find.byKey(const Key('sms-parse-button')));
  await tester.tap(find.byKey(const Key('sms-parse-button')));
  await settle(tester);
}

class ThrowingScanGateway implements SmsGateway {
  const ThrowingScanGateway();

  @override
  bool get inboxSupported => true;

  @override
  Future<bool> hasPermission() async => true;

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<List<RawSms>> readSince(DateTime? since, Set<String> senders) {
    throw StateError('scan failed');
  }

  @override
  Stream<RawSms> get incoming => const Stream.empty();

  @override
  Stream<String> get sharedText => const Stream.empty();

  @override
  Future<String?> takeInitialSharedText() async => null;
}

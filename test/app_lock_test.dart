import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ledgr/data/db/app_database.dart';
import 'package:ledgr/data/repositories/settings_repository_impl.dart';
import 'package:ledgr/domain/biometric/biometric_authenticator.dart';

import 'support/ledgr_harness.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('biometric lock stays up until unlock succeeds', (tester) async {
    await SettingsRepositoryImpl(db).setBiometricLockEnabled(true);
    final auth = _ScriptedAuth([false, true]);
    await pumpApp(tester, db: db, biometrics: auth);

    expect(find.byKey(const Key('app-lock-screen')), findsOneWidget);
    expect(auth.calls, 1);

    await tester.tap(find.byKey(const Key('app-lock-unlock')));
    await tester.pump();
    await tester.pump();

    expect(find.byKey(const Key('app-lock-screen')), findsNothing);
    expect(find.byKey(const Key('month-balance')), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('backgrounding the app requires biometrics again', (tester) async {
    await SettingsRepositoryImpl(db).setBiometricLockEnabled(true);
    final auth = _ScriptedAuth([true, true]);
    await pumpApp(tester, db: db, biometrics: auth);

    expect(find.byKey(const Key('month-balance')), findsOneWidget);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();

    expect(find.byKey(const Key('app-lock-screen')), findsOneWidget);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    await tester.pump();

    expect(find.byKey(const Key('app-lock-screen')), findsNothing);
    expect(auth.calls, 2);
    await disposeApp(tester);
  });

  testWidgets('app lock toggle stores the choice after biometrics succeed',
      (tester) async {
    final auth = _ScriptedAuth([true]);
    await pumpApp(tester, db: db, biometrics: auth);

    await tester.tap(find.byKey(const Key('tab-settings')));
    await settle(tester);
    await tester.dragUntilVisible(
      find.byKey(const Key('settings-app-lock')),
      find.byKey(const Key('settings-scroll')),
      const Offset(0, -200),
    );
    await tester.tap(find.byKey(const Key('settings-app-lock')));
    await tester.pump();
    await tester.pump();

    expect(auth.calls, 1);
    expect(
      (await SettingsRepositoryImpl(db).get()).biometricLockEnabled,
      isTrue,
    );
    await disposeApp(tester);
  });

  testWidgets('app lock stays off when biometrics are not enrolled',
      (tester) async {
    final auth = _ScriptedAuth(const [], available: false);
    await pumpApp(tester, db: db, biometrics: auth);

    await tester.tap(find.byKey(const Key('tab-settings')));
    await settle(tester);
    await tester.dragUntilVisible(
      find.byKey(const Key('settings-app-lock')),
      find.byKey(const Key('settings-scroll')),
      const Offset(0, -200),
    );
    await tester.tap(find.byKey(const Key('settings-app-lock')));
    await tester.pump();

    expect(find.text('Biometrics unavailable'), findsOneWidget);
    expect(auth.calls, 0);
    expect(
      (await SettingsRepositoryImpl(db).get()).biometricLockEnabled,
      isFalse,
    );
    await disposeApp(tester);
  });
}

class _ScriptedAuth implements BiometricAuthenticator {
  _ScriptedAuth(List<bool> results, {this.available = true})
      : _results = List.of(results);

  final bool available;
  final List<bool> _results;
  var calls = 0;

  @override
  Future<BiometricAvailability> availability() async {
    return available
        ? BiometricAvailability.available
        : BiometricAvailability.notEnrolled;
  }

  @override
  Future<bool> authenticate({required String reason}) async {
    calls++;
    if (_results.isEmpty) return false;
    return _results.removeAt(0);
  }
}

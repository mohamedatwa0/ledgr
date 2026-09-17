import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ledgr/data/sms/android_sms_gateway.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('missing native plugin does not throw', () async {
    const channel = MethodChannel('ledgr/sms');
    const incoming = EventChannel('ledgr/sms/incoming');
    const share = EventChannel('ledgr/sms/share');
    final gateway = AndroidSmsGateway(
      channel: channel,
      incoming: incoming,
      share: share,
    );

    expect(await gateway.hasPermission(), isFalse);
    expect(await gateway.requestPermission(), isFalse);
    expect(await gateway.readSince(null, {}), isEmpty);
    expect(await gateway.takeInitialSharedText(), isNull);
    expect(await gateway.incoming.isEmpty, isTrue);
    expect(await gateway.sharedText.isEmpty, isTrue);
  });
}

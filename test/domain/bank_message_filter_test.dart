import 'package:flutter_test/flutter_test.dart';
import 'package:ledgr/domain/sms/bank_message_filter.dart';

void main() {
  test('accepts known bank and wallet texts', () {
    expect(
      isBankOrWalletMessage(
        sender: 'paste',
        body: 'CIB: Purchase of EGP 250.00 at STARBUCKS using card ending 1234',
      ),
      isTrue,
    );
    expect(
      isBankOrWalletMessage(
        sender: 'share',
        body: 'تم خصم مبلغ 80.00 جنيه في Uber بتاريخ 01/09/2026',
      ),
      isTrue,
    );
    expect(
      isBankOrWalletMessage(
        sender: 'VF-Cash',
        body: 'Your wallet was charged EGP 50.00',
      ),
      isTrue,
    );
    expect(
      isBankOrWalletMessage(
        sender: '',
        body: 'InstaPay: You sent EGP 1,000.00 to AHMED. Ref: 12345',
      ),
      isTrue,
    );
    expect(
      isBankOrWalletMessage(
        sender: 'Messages',
        body: 'Purchase of EGP 250.00 using card ending 1234',
      ),
      isTrue,
    );
    expect(
      isBankOrWalletMessage(
        sender: 'AAIB',
        body: 'Your account was debited EGP 100.00',
      ),
      isTrue,
    );
    expect(
      isBankOrWalletMessage(
        sender: 'share',
        body: 'بنك الإسكندرية: تم خصم 20.00 جنيه',
      ),
      isTrue,
    );
    expect(
      isBankOrWalletMessage(
        sender: 'paste',
        body: 'Fawry: You paid EGP 75.00',
      ),
      isTrue,
    );
    expect(
      isBankOrWalletMessage(
        sender: 'share',
        body: 'تم خصم 30 جنيه من فون كاش الأهلي',
      ),
      isTrue,
    );
    expect(
      isBankOrWalletMessage(
        sender: 'Halan',
        body: 'Payment received EGP 20.00',
      ),
      isTrue,
    );
  });

  test('rejects personal messages, promos, and one-time codes', () {
    expect(
      isBankOrWalletMessage(sender: 'Mom', body: 'Can you send me 50 EGP?'),
      isFalse,
    );
    expect(
      isBankOrWalletMessage(
        sender: 'CIB',
        body: 'Your OTP is 123456. Do not share it.',
      ),
      isFalse,
    );
    expect(
      isBankOrWalletMessage(
        sender: 'paste',
        body: 'Win EGP 1000! Click here to claim.',
      ),
      isFalse,
    );
    expect(
      isBankOrWalletMessage(sender: 'share', body: 'See you at 7'),
      isFalse,
    );
    expect(
      isBankOrWalletMessage(sender: 'CIB', body: 'Hello from the bank'),
      isFalse,
    );
  });

  test('known sender still needs a transaction-shaped body', () {
    expect(
      isBankOrWalletMessage(
        sender: 'CIB',
        body: 'Your monthly statement is ready',
      ),
      isFalse,
    );
    expect(
      isBankOrWalletMessage(
        sender: 'NBE',
        body: 'Thank you for banking with us. Ref 998877',
      ),
      isFalse,
    );
  });
}

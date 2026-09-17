import 'package:flutter_test/flutter_test.dart';
import 'package:ledgr/domain/models/transaction_type.dart';
import 'package:ledgr/domain/sms/keyword_categorizer.dart';
import 'package:ledgr/domain/sms/money_parse.dart';
import 'package:ledgr/domain/sms/sms_message.dart';
import 'package:ledgr/domain/sms/sms_parser.dart';

RawSms _sms(String sender, String body) {
  return RawSms(
    sender: sender,
    body: body,
    receivedAt: DateTime(2026, 9, 15, 12),
  );
}

void main() {
  const parser = SmsParser();

  group('SmsParser banks', () {
    test('CIB English purchase', () {
      final parsed = parser.parse(
        _sms(
          'CIB',
          'CIB: Purchase of EGP 250.00 at STARBUCKS using card ending 1234 '
              'on 15/09/2026. Available balance EGP 5,000.00',
        ),
      );
      expect(parsed, isNotNull);
      expect(parsed!.amount, 25000);
      expect(parsed.type, TransactionType.expense);
      expect(parsed.bankId, 'CIB');
      expect(parsed.merchant, 'STARBUCKS');
      expect(parsed.valueDate, DateTime(2026, 9, 15));
      expect(parsed.currencyCode, 'EGP');
    });

    test('CIB Arabic debit with Eastern Arabic digits', () {
      final parsed = parser.parse(
        _sms(
          'CIB',
          'تم خصم مبلغ ٢٥٠.٠٠ جنيه من بطاقتك في ستاربكس بتاريخ 15/09/2026',
        ),
      );
      expect(parsed, isNotNull);
      expect(parsed!.amount, 25000);
      expect(parsed.type, TransactionType.expense);
      expect(parsed.bankId, 'CIB');
      expect(parsed.merchant, contains('ستاربكس'));
    });

    test('NBE English ATM withdrawal', () {
      final parsed = parser.parse(
        _sms(
          'NBE',
          'NBE: EGP 500.00 withdrawn from acct **1234 on 15-09-2026. '
              'Avl Bal EGP 3,000.00',
        ),
      );
      expect(parsed, isNotNull);
      expect(parsed!.amount, 50000);
      expect(parsed.type, TransactionType.expense);
      expect(parsed.bankId, 'NBE');
      expect(parsed.valueDate, DateTime(2026, 9, 15));
    });

    test('NBE Arabic withdrawal', () {
      final parsed = parser.parse(
        _sms('NBE', 'تم سحب ٥٠٠.٠٠ جنيه بتاريخ 15/09/2026'),
      );
      expect(parsed, isNotNull);
      expect(parsed!.amount, 50000);
      expect(parsed.type, TransactionType.expense);
    });

    test('Banque Misr English purchase', () {
      final parsed = parser.parse(
        _sms(
          'BM',
          'Banque Misr: purchased EGP 1,250.50 at CARREFOUR on 15/09/2026',
        ),
      );
      expect(parsed, isNotNull);
      expect(parsed!.amount, 125050);
      expect(parsed.type, TransactionType.expense);
      expect(parsed.bankId, 'BM');
      expect(parsed.merchant, 'CARREFOUR');
    });

    test('Banque Misr Arabic debit', () {
      final parsed = parser.parse(
        _sms('BANQUEMISR', 'تم خصم مبلغ 80.00 جنيه في Uber بتاريخ 01/09/2026'),
      );
      expect(parsed, isNotNull);
      expect(parsed!.amount, 8000);
      expect(parsed.merchant, 'Uber');
    });

    test('QNB English POS', () {
      final parsed = parser.parse(
        _sms('QNB', 'QNB: POS EGP 90.00 at NOON on 2026-09-15'),
      );
      expect(parsed, isNotNull);
      expect(parsed!.amount, 9000);
      expect(parsed.bankId, 'QNB');
      expect(parsed.merchant, 'NOON');
    });

    test('QNB Arabic credit', () {
      final parsed = parser.parse(
        _sms('QNBALA', 'تم إيداع 6000.00 جنيه بتاريخ 15/09/2026'),
      );
      expect(parsed, isNotNull);
      expect(parsed!.amount, 600000);
      expect(parsed.type, TransactionType.income);
    });

    test('Banque du Caire English debit', () {
      final parsed = parser.parse(
        _sms('BDC', 'BDC: withdrawn EGP 200.00 on 15/09/26'),
      );
      expect(parsed, isNotNull);
      expect(parsed!.amount, 20000);
      expect(parsed.bankId, 'BDC');
    });

    test('Banque du Caire Arabic credit', () {
      final parsed = parser.parse(
        _sms('BDC', 'تم ايداع 1000 جنيه بتاريخ 15/09/2026'),
      );
      expect(parsed, isNotNull);
      expect(parsed!.type, TransactionType.income);
      expect(parsed.amount, 100000);
    });

    test('InstaPay sent is expense', () {
      final parsed = parser.parse(
        _sms('InstaPay', 'InstaPay: You sent EGP 1,000.00 to AHMED. Ref: 12345'),
      );
      expect(parsed, isNotNull);
      expect(parsed!.type, TransactionType.expense);
      expect(parsed.amount, 100000);
      expect(parsed.bankId, 'INSTAPAY');
      expect(parsed.merchant, 'AHMED');
    });

    test('InstaPay received is income', () {
      final parsed = parser.parse(
        _sms(
          'IPN',
          'InstaPay: You received EGP 1,000.00 from SARA. Ref: 999',
        ),
      );
      expect(parsed, isNotNull);
      expect(parsed!.type, TransactionType.income);
      expect(parsed.amount, 100000);
      expect(parsed.merchant, 'SARA');
    });

    test('InstaPay Arabic sent and received', () {
      final sent = parser.parse(
        _sms('INSTAPAY', 'تم تحويل 250.00 جنيه إلى محمد'),
      );
      expect(sent!.type, TransactionType.expense);
      expect(sent.amount, 25000);

      final received = parser.parse(
        _sms('INSTAPAY', 'استلمت 250.00 جنيه من محمد'),
      );
      expect(received!.type, TransactionType.income);
      expect(received.amount, 25000);
    });
  });

  group('SmsParser fail-closed', () {
    test('OTP is unmatched', () {
      expect(
        parser.parse(_sms('CIB', 'Your OTP is 452189. Do not share it.')),
        isNull,
      );
      expect(
        parser.parse(_sms('NBE', 'رمز التحقق 123456')),
        isNull,
      );
    });

    test('promo without debit/credit keyword is unmatched', () {
      expect(
        parser.parse(_sms('CIB', 'Win EGP 1000! Click here to claim.')),
        isNull,
      );
    });
  });

  group('money and categories', () {
    test('parses US and European thousands', () {
      expect(parseSmsAmount('1,250.50'), 125050);
      expect(parseSmsAmount('1.250,50'), 125050);
      expect(parseSmsAmount('45'), 4500);
    });

    test('keyword categorizer mappings', () {
      expect(
        suggestCategoryName(
          haystack: 'STARBUCKS',
          type: TransactionType.expense,
        ),
        'Food & Dining',
      );
      expect(
        suggestCategoryName(haystack: 'UBER trip', type: TransactionType.expense),
        'Transport',
      );
      expect(
        suggestCategoryName(haystack: 'NOON order', type: TransactionType.expense),
        'Shopping',
      );
      expect(
        suggestCategoryName(
          haystack: 'Vodafone bill',
          type: TransactionType.expense,
        ),
        'Bills & Utilities',
      );
      expect(
        suggestCategoryName(
          haystack: 'pharmacy',
          type: TransactionType.expense,
        ),
        'Health',
      );
      expect(
        suggestCategoryName(haystack: 'netflix', type: TransactionType.expense),
        'Entertainment',
      );
      expect(
        suggestCategoryName(
          haystack: 'InstaPay sent to AHMED',
          type: TransactionType.expense,
        ),
        'Transfer',
      );
      expect(
        suggestCategoryName(haystack: 'monthly salary', type: TransactionType.income),
        'Salary',
      );
      expect(
        suggestCategoryName(haystack: 'ATM withdrawal', type: TransactionType.expense),
        isNull,
      );
    });
  });
}

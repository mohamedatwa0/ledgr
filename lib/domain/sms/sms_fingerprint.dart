import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'sms_message.dart';
import 'sms_normalize.dart';

String smsFingerprint(RawSms sms) {
  return textSmsFingerprint(sms.sender, sms.body);
}

String textSmsFingerprint(String sender, String body) {
  final normalized = '${normalizeSender(sender)}|${normalizeSmsText(body)}';
  return 'text:${sha256.convert(utf8.encode(normalized))}';
}

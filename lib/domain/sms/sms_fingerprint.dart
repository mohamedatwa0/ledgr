import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'sms_message.dart';
import 'sms_normalize.dart';

String smsFingerprint(RawSms sms) {
  final platformId = sms.platformMessageId?.trim();
  if (platformId != null && platformId.isNotEmpty) {
    return 'android:$platformId';
  }
  final normalized =
      '${normalizeSender(sms.sender)}|${normalizeSmsText(sms.body)}';
  return 'text:${sha256.convert(utf8.encode(normalized))}';
}

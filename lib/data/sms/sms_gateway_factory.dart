import 'dart:io';

import '../../domain/sms/sms_gateway.dart';
import 'android_sms_gateway.dart';
import 'noop_sms_gateway.dart';

SmsGateway createSmsGateway() {
  if (Platform.isAndroid) return AndroidSmsGateway();
  return const NoOpSmsGateway();
}

import '../../../../domain/sms/sms_inbox_item.dart';
import 'sms_inbox_event.dart';

class SmsInboxState {
  const SmsInboxState({
    required this.filter,
    required this.items,
    required this.pasteText,
    required this.inboxSupported,
    required this.hasPermission,
    this.loading = false,
    this.scanning = false,
    this.parsing = false,
    this.message,
  });

  final SmsInboxFilter filter;
  final List<SmsInboxItem> items;
  final String pasteText;
  final bool inboxSupported;
  final bool hasPermission;
  final bool loading;
  final bool scanning;
  final bool parsing;
  final String? message;

  SmsInboxState copyWith({
    SmsInboxFilter? filter,
    List<SmsInboxItem>? items,
    String? pasteText,
    bool? inboxSupported,
    bool? hasPermission,
    bool? loading,
    bool? scanning,
    bool? parsing,
    String? message,
    bool clearMessage = false,
  }) {
    return SmsInboxState(
      filter: filter ?? this.filter,
      items: items ?? this.items,
      pasteText: pasteText ?? this.pasteText,
      inboxSupported: inboxSupported ?? this.inboxSupported,
      hasPermission: hasPermission ?? this.hasPermission,
      loading: loading ?? this.loading,
      scanning: scanning ?? this.scanning,
      parsing: parsing ?? this.parsing,
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}

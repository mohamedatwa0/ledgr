import '../../../../domain/sms/sms_inbox_item.dart';
import '../../../../domain/sms/sms_inbox_status.dart';

enum SmsInboxFilter { toReview, unmatched, imported }

extension SmsInboxFilterX on SmsInboxFilter {
  SmsInboxStatus get status {
    switch (this) {
      case SmsInboxFilter.toReview:
        return SmsInboxStatus.ready;
      case SmsInboxFilter.unmatched:
        return SmsInboxStatus.unmatched;
      case SmsInboxFilter.imported:
        return SmsInboxStatus.imported;
    }
  }
}

abstract class SmsInboxEvent {
  const SmsInboxEvent();
}

class SmsInboxStarted extends SmsInboxEvent {
  const SmsInboxStarted();
}

class SmsInboxFilterChanged extends SmsInboxEvent {
  const SmsInboxFilterChanged(this.filter);

  final SmsInboxFilter filter;
}

class SmsInboxPasteChanged extends SmsInboxEvent {
  const SmsInboxPasteChanged(this.text);

  final String text;
}

class SmsInboxParseRequested extends SmsInboxEvent {
  const SmsInboxParseRequested([this.text = '']);

  final String text;
}

class SmsInboxScanRequested extends SmsInboxEvent {
  const SmsInboxScanRequested();
}

class SmsInboxPermissionRequested extends SmsInboxEvent {
  const SmsInboxPermissionRequested();
}

class SmsInboxDismissRequested extends SmsInboxEvent {
  const SmsInboxDismissRequested(this.id);

  final int id;
}

class SmsInboxItemsUpdated extends SmsInboxEvent {
  const SmsInboxItemsUpdated(this.items);

  final List<SmsInboxItem> items;
}

class SmsInboxPermissionUpdated extends SmsInboxEvent {
  const SmsInboxPermissionUpdated(this.granted);

  final bool granted;
}

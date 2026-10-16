import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/sms/bank_message_filter.dart';
import '../../domain/sms/sms_gateway.dart';
import '../../domain/sms/sms_message.dart';
import '../../domain/usecases/ingest_sms.dart';
import '../../domain/usecases/scan_sms_inbox.dart';

class SmsIntakeHost extends StatefulWidget {
  const SmsIntakeHost({
    super.key,
    required this.router,
    required this.child,
  });

  final GoRouter router;
  final Widget child;

  @override
  State<SmsIntakeHost> createState() => _SmsIntakeHostState();
}

class _SmsIntakeHostState extends State<SmsIntakeHost>
    with WidgetsBindingObserver {
  StreamSubscription<void>? _incoming;
  StreamSubscription<void>? _share;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listen();
      _importPending();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _incoming?.cancel();
    _share?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _importPending();
    }
  }

  void _listen() {
    final gateway = context.read<SmsGateway>();
    final ingest = context.read<IngestSms>();
    _incoming = gateway.incoming.listen(
      (sms) {
        if (!isBankOrWalletMessage(sender: sms.sender, body: sms.body)) return;
        ingest(sms);
      },
      onError: (_) {},
    );
    _share = gateway.sharedText.listen((text) {
      if (text == kSmsImportSignal) {
        _importPending();
        return;
      }
      _ingestShared(text);
    }, onError: (_) {});
  }

  Future<void> _importPending() async {
    if (!mounted) return;
    final gateway = context.read<SmsGateway>();
    final scan = context.read<ScanSmsInbox>();
    final pending = await gateway.takeInitialSharedText();
    if (!mounted) return;
    await scan();
    if (!mounted || pending == null || pending.trim().isEmpty) return;
    if (pending == kSmsImportSignal) {
      _openInbox();
      return;
    }
    await _ingestShared(pending);
  }

  void _openInbox() {
    final path = widget.router.state.uri.path;
    if (path == '/settings/sms' || path.startsWith('/settings/sms/')) return;
    widget.router.push('/settings/sms');
  }

  Future<void> _ingestShared(String text) async {
    if (!mounted) return;
    if (!isBankOrWalletMessage(sender: 'share', body: text)) return;
    await context.read<IngestSms>()(pasteRawSms(text, sender: 'share'));
    if (!mounted) return;
    _openInbox();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

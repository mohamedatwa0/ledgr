import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/sms/sms_gateway.dart';
import '../../domain/sms/sms_normalize.dart';
import '../../domain/sms/templates/template_registry.dart';
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
      _scanIfAllowed();
      _takeShared();
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
      _scanIfAllowed();
    }
  }

  void _listen() {
    final gateway = context.read<SmsGateway>();
    final ingest = context.read<IngestSms>();
    final allowlist = smsSenderAllowlist();
    _incoming = gateway.incoming.listen(
      (sms) {
        if (!senderMatchesAllowlist(sms.sender, allowlist)) return;
        ingest(sms);
      },
      onError: (_) {},
    );
    _share = gateway.sharedText.listen(_ingestShared, onError: (_) {});
  }

  Future<void> _takeShared() async {
    final text = await context.read<SmsGateway>().takeInitialSharedText();
    if (text != null && text.trim().isNotEmpty) {
      await _ingestShared(text);
    }
  }

  Future<void> _ingestShared(String text) async {
    if (!mounted) return;
    await context.read<IngestSms>()(pasteRawSms(text, sender: 'share'));
    if (!mounted) return;
    widget.router.go('/settings/sms');
  }

  Future<void> _scanIfAllowed() async {
    if (!mounted) return;
    await context.read<ScanSmsInbox>()();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

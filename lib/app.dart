import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'data/db/app_database.dart';
import 'domain/sms/sms_gateway.dart';
import 'presentation/di/ledgr_scope.dart';
import 'presentation/router/app_router.dart';
import 'presentation/sms_intake_host.dart';
import 'theme/theme.dart';

class LedgrApp extends StatefulWidget {
  const LedgrApp({
    super.key,
    this.database,
    this.smsGateway,
  });

  final AppDatabase? database;
  final SmsGateway? smsGateway;

  @override
  State<LedgrApp> createState() => _LedgrAppState();
}

class _LedgrAppState extends State<LedgrApp> {
  late final GoRouter _router = createAppRouter();

  @override
  Widget build(BuildContext context) {
    return LedgrScope(
      database: widget.database,
      smsGateway: widget.smsGateway,
      child: SmsIntakeHost(
        router: _router,
        child: MaterialApp.router(
          title: 'Ledgr',
          theme: ledgrTheme,
          routerConfig: _router,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

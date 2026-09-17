import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'data/db/app_database.dart';
import 'presentation/di/ledgr_scope.dart';
import 'presentation/router/app_router.dart';
import 'theme/theme.dart';

class LedgrApp extends StatefulWidget {
  const LedgrApp({super.key, this.database});

  final AppDatabase? database;

  @override
  State<LedgrApp> createState() => _LedgrAppState();
}

class _LedgrAppState extends State<LedgrApp> {
  late final GoRouter _router = createAppRouter();

  @override
  Widget build(BuildContext context) {
    return LedgrScope(
      database: widget.database,
      child: MaterialApp.router(
        title: 'Ledgr',
        theme: ledgrTheme,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

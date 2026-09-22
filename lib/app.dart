import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'data/db/app_database.dart';
import 'domain/models/app_locale.dart';
import 'domain/models/app_settings.dart';
import 'domain/models/app_theme_mode.dart';
import 'domain/repositories/settings_repository.dart';
import 'domain/sms/sms_gateway.dart';
import 'l10n/app_localizations.dart';
import 'presentation/di/ledgr_scope.dart';
import 'presentation/router/app_router.dart';
import 'presentation/sms_intake_host.dart';
import 'presentation/widgets/ledgr_launch_screen.dart';
import 'theme/theme.dart';

class LedgrApp extends StatefulWidget {
  const LedgrApp({
    super.key,
    this.database,
    this.smsGateway,
    this.showLaunchScreen = true,
  });

  final AppDatabase? database;
  final SmsGateway? smsGateway;
  final bool showLaunchScreen;

  @override
  State<LedgrApp> createState() => _LedgrAppState();
}

class _LedgrAppState extends State<LedgrApp> {
  late final GoRouter _router = createAppRouter();
  var _showSplash = true;
  ui.Picture? _launchIcon;
  Size _launchIconSize = Size.zero;

  @override
  void initState() {
    super.initState();
    if (!widget.showLaunchScreen) {
      _showSplash = false;
      return;
    }
    WidgetsBinding.instance.deferFirstFrame();
    _loadLaunchIcon();
  }

  Future<void> _loadLaunchIcon() async {
    try {
      final info = await vg
          .loadPicture(
            SvgAssetLoader(
              'assets/branding/ledger_icon.svg',
              assetBundle: rootBundle,
            ),
            null,
          )
          .timeout(const Duration(seconds: 3));
      if (!mounted) {
        info.picture.dispose();
      } else {
        _launchIcon = info.picture;
        _launchIconSize = info.size;
        setState(() {});
      }
    } catch (error, stackTrace) {
      debugPrint('Ledgr launch icon failed: $error\n$stackTrace');
    }
    WidgetsBinding.instance.allowFirstFrame();
    if (!mounted) return;
    Future<void>.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _showSplash = false);
    });
  }

  @override
  void dispose() {
    _launchIcon?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (context, _) => LedgrScope(
        database: widget.database,
        smsGateway: widget.smsGateway,
        child: SmsIntakeHost(
          router: _router,
          child: Builder(
            builder: (context) {
              return StreamBuilder<AppSettings>(
                stream: context.read<SettingsRepository>().watch(),
                builder: (context, snapshot) {
                  final mode = snapshot.data?.themeMode ?? AppThemeMode.system;
                  final locale = snapshot.data?.locale ?? AppLocale.en;
                  if (_showSplash) {
                    return MaterialApp(
                      title: 'Ledgr',
                      theme: ledgrLightTheme,
                      darkTheme: ledgrDarkTheme,
                      themeMode: mode.material,
                      debugShowCheckedModeBanner: false,
                      home: LedgrLaunchScreen(
                        picture: _launchIcon,
                        pictureSize: _launchIconSize,
                      ),
                    );
                  }
                  return MaterialApp.router(
                    title: 'Ledgr',
                    theme: ledgrLightTheme,
                    darkTheme: ledgrDarkTheme,
                    themeMode: mode.material,
                    locale: locale.material,
                    supportedLocales: AppLocalizations.supportedLocales,
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,
                    routerConfig: _router,
                    debugShowCheckedModeBanner: false,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

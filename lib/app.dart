import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'data/db/app_database.dart';
import 'domain/biometric/biometric_authenticator.dart';
import 'domain/models/app_locale.dart';
import 'domain/models/app_settings.dart';
import 'domain/models/app_theme_mode.dart';
import 'domain/repositories/settings_repository.dart';
import 'domain/sms/sms_gateway.dart';
import 'l10n/app_localizations.dart';
import 'presentation/app_lock/app_lock_screen.dart';
import 'presentation/app_lock/app_lock_session.dart';
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
    this.biometricAuthenticator,
    this.showLaunchScreen = true,
  });

  final AppDatabase? database;
  final SmsGateway? smsGateway;
  final BiometricAuthenticator? biometricAuthenticator;
  final bool showLaunchScreen;

  @override
  State<LedgrApp> createState() => _LedgrAppState();
}

class _LedgrAppState extends State<LedgrApp> with WidgetsBindingObserver {
  late final GoRouter _router = createAppRouter();
  late final AppLockSession _session = AppLockSession();
  var _showSplash = true;
  var _lockEnabled = false;
  var _privacyCover = false;
  var _lockedForBackground = false;
  ui.Picture? _launchIcon;
  Size _launchIconSize = Size.zero;
  ChildBackButtonDispatcher? _backButton;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _session.addListener(_onSessionChanged);
    if (!widget.showLaunchScreen) {
      _showSplash = false;
      return;
    }
    WidgetsBinding.instance.deferFirstFrame();
    _loadLaunchIcon();
  }

  void _claimBackButton() {
    if (!mounted || _backButton != null) return;
    final parent = _router.backButtonDispatcher;
    if (!parent.hasCallbacks) return;
    final child = parent.createChildBackButtonDispatcher()
      ..addCallback(() {
        final blocked = _lockEnabled && (!_session.unlocked || _privacyCover);
        return Future<bool>.value(blocked);
      })
      ..takePriority();
    _backButton = child;
  }

  void _onSessionChanged() {
    if (!mounted) return;
    setState(() {
      if (_session.unlocked) _privacyCover = false;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_lockEnabled) return;
    switch (state) {
      case AppLifecycleState.inactive:
        _showCover();
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (!_session.authenticating && !_lockedForBackground) {
          _lockedForBackground = true;
          _session.lock();
        }
        _showCover();
      case AppLifecycleState.resumed:
        _lockedForBackground = false;
        if (_session.unlocked) _hideCover();
    }
  }

  void _showCover() {
    if (_privacyCover || !mounted) return;
    setState(() => _privacyCover = true);
  }

  void _hideCover() {
    if (!_privacyCover || !mounted) return;
    setState(() => _privacyCover = false);
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
    WidgetsBinding.instance.removeObserver(this);
    _session.removeListener(_onSessionChanged);
    final backButton = _backButton;
    if (backButton != null) {
      _router.backButtonDispatcher.forget(backButton);
    }
    _session.dispose();
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
        appLock: _session,
        biometrics: widget.biometricAuthenticator,
        child: SmsIntakeHost(
          child: Builder(
            builder: (context) {
              return StreamBuilder<AppSettings>(
                stream: context.read<SettingsRepository>().watch(),
                builder: (context, snapshot) {
                  final mode = snapshot.data?.themeMode ?? AppThemeMode.system;
                  final locale = snapshot.data?.locale ?? AppLocale.en;
                  final waiting = !snapshot.hasData && !snapshot.hasError;
                  if (snapshot.hasError) {
                    return MaterialApp(
                      title: 'Ledgr',
                      theme: ledgrLightTheme,
                      darkTheme: ledgrDarkTheme,
                      themeMode: mode.material,
                      locale: locale.material,
                      supportedLocales: AppLocalizations.supportedLocales,
                      localizationsDelegates:
                          AppLocalizations.localizationsDelegates,
                      debugShowCheckedModeBanner: false,
                      home: Builder(
                        builder: (context) {
                          return Scaffold(
                            body: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .settingsLoadFailed,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  _lockEnabled = snapshot.data?.biometricLockEnabled ?? false;
                  final locked = _lockEnabled && !_session.unlocked;
                  if (_showSplash || (widget.showLaunchScreen && waiting)) {
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
                  final biometrics = context.read<BiometricAuthenticator>();
                  if (_backButton == null) {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) => _claimBackButton(),
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
                    builder: (context, child) {
                      final obscured =
                          locked || (_privacyCover && _lockEnabled);
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          if (child != null)
                            IgnorePointer(
                              ignoring: obscured,
                              child: ExcludeSemantics(
                                excluding: obscured,
                                child: child,
                              ),
                            ),
                          if (locked)
                            Positioned.fill(
                              child: AppLockScreen(
                                key: ValueKey(_session.generation),
                                session: _session,
                                authenticator: biometrics,
                              ),
                            )
                          else if (_privacyCover && _lockEnabled)
                            const Positioned.fill(
                              child: AppLockCover(
                                key: Key('app-lock-cover'),
                              ),
                            ),
                        ],
                      );
                    },
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

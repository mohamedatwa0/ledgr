import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../domain/biometric/biometric_authenticator.dart';
import '../../l10n/l10n.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../widgets/ledgr_primary_button.dart';
import 'app_lock_session.dart';

class AppLockCover extends StatelessWidget {
  const AppLockCover({super.key, this.message, this.footer});

  final String? message;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(32.w, 24.h, 32.w, 24.h),
          child: Column(
            children: [
              const Spacer(),
              Icon(TablerIcons.lock, size: 36.r, color: colors.primary),
              SizedBox(height: 16.h),
              Text(
                'Ledgr',
                style: amountStyle(fontSize: 40, color: colors.onSurface),
              ),
              if (message != null) ...[
                SizedBox(height: 12.h),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: uiStyle(fontSize: 16, color: colors.secondary),
                ),
              ],
              const Spacer(),
              footer ?? SizedBox(height: 48.h),
            ],
          ),
        ),
      ),
    );
  }
}

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({
    super.key,
    required this.session,
    required this.authenticator,
  });

  final AppLockSession session;
  final BiometricAuthenticator authenticator;

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen>
    with WidgetsBindingObserver {
  var _autoPrompted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prompt(automatic: true);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _prompt(automatic: true);
    }
  }

  Future<void> _prompt({required bool automatic}) async {
    if (!mounted || widget.session.authenticating) return;
    if (automatic && _autoPrompted) return;
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    if (automatic &&
        lifecycle != null &&
        lifecycle != AppLifecycleState.resumed) {
      return;
    }
    if (automatic) _autoPrompted = true;
    await widget.session.authenticate(
      widget.authenticator,
      reason: context.l10n.appLockUnlockReason,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final busy = widget.session.authenticating;
    return AppLockCover(
      key: const Key('app-lock-screen'),
      message: l10n.appLockPrompt,
      footer: LedgrPrimaryButton(
        key: const Key('app-lock-unlock'),
        label: l10n.appLockUnlock,
        onPressed: busy ? null : () => _prompt(automatic: false),
      ),
    );
  }
}

import 'package:flutter/widgets.dart';

import '../../domain/biometric/biometric_authenticator.dart';

class AppLockSession {
  final List<VoidCallback> _listeners = [];
  bool _unlocked = false;
  bool _authenticating = false;
  int _generation = 0;

  bool get unlocked => _unlocked;
  bool get authenticating => _authenticating;
  int get generation => _generation;

  void addListener(VoidCallback listener) => _listeners.add(listener);

  void removeListener(VoidCallback listener) => _listeners.remove(listener);

  void dispose() => _listeners.clear();

  void lock() {
    if (_authenticating) return;
    _unlocked = false;
    _generation++;
    _notify();
  }

  Future<bool> authenticate(
    BiometricAuthenticator authenticator, {
    required String reason,
  }) async {
    if (_authenticating) return false;
    _authenticating = true;
    _notify();
    try {
      final ok = await authenticator.authenticate(reason: reason);
      if (_isBackgrounded) {
        _unlocked = false;
        _generation++;
        return false;
      }
      if (ok) _unlocked = true;
      return ok;
    } finally {
      _authenticating = false;
      _notify();
    }
  }

  void _notify() {
    for (final listener in List<VoidCallback>.of(_listeners)) {
      listener();
    }
  }

  bool get _isBackgrounded {
    final state = WidgetsBinding.instance.lifecycleState;
    return state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../domain/models/app_locale.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/voice/parse_voice_entry.dart';
import '../../l10n/l10n.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';

class AddEntryFab extends StatefulWidget {
  const AddEntryFab({super.key});

  @override
  State<AddEntryFab> createState() => _AddEntryFabState();
}

class _AddEntryFabState extends State<AddEntryFab> {
  var _expanded = false;
  var _listening = false;
  var _liveText = '';
  SpeechToText? _speech;

  @override
  void dispose() {
    _speech?.stop();
    super.dispose();
  }

  void _toggleMenu() {
    if (_listening) {
      _speech?.stop();
      setState(() {
        _listening = false;
        _expanded = false;
        _liveText = '';
      });
      return;
    }
    setState(() => _expanded = !_expanded);
  }

  void _openManual() {
    setState(() => _expanded = false);
    context.push('/transaction/new');
  }

  Future<void> _openVoice() async {
    final l10n = context.l10n;
    try {
      final speech = _speech ??= SpeechToText();
      final available = await speech.initialize(
        onError: (error) {
          if (!mounted) return;
          final code = error.errorMsg.toLowerCase();
          if (code.contains('permission')) {
            _finishListen(message: l10n.voicePermissionDenied);
            return;
          }
          if (code.contains('no_match') ||
              code.contains('timeout') ||
              code.contains('speech_timeout')) {
            _completeTranscript(_bestTranscript());
            return;
          }
          _finishListen(message: l10n.voiceUnavailable);
        },
        onStatus: (status) {
          if (!mounted || !_listening) return;
          if (status != SpeechToText.doneStatus) return;
          if (_bestTranscript().isNotEmpty) {
            _completeTranscript(_bestTranscript());
            return;
          }
          // Android often sends done before the last words arrive.
          Future<void>.delayed(const Duration(milliseconds: 500), () {
            if (!mounted || !_listening) return;
            _completeTranscript(_bestTranscript());
          });
        },
      );
      if (!mounted) return;
      if (!available) {
        _showMessage(l10n.voiceUnavailable);
        return;
      }

      final settings = await context.read<SettingsRepository>().get();
      if (!mounted) return;
      final localeId = await _localeIdFor(speech, settings.locale);
      if (!mounted) return;

      setState(() {
        _listening = true;
        _liveText = '';
      });

      await speech.listen(
        listenOptions: SpeechListenOptions(
          localeId: localeId,
          listenFor: const Duration(seconds: 20),
          pauseFor: const Duration(seconds: 5),
          listenMode: ListenMode.dictation,
          partialResults: true,
        ),
        onResult: (result) {
          if (!mounted) return;
          setState(() => _liveText = result.recognizedWords);
          if (!result.finalResult) return;
          _completeTranscript(result.recognizedWords);
        },
      );
    } on MissingPluginException {
      if (!mounted) return;
      _speech = null;
      _finishListen(message: l10n.voiceUnavailable);
    } catch (_) {
      if (!mounted) return;
      _speech = null;
      _finishListen(message: l10n.voiceUnavailable);
    }
  }

  Future<String?> _localeIdFor(SpeechToText speech, AppLocale appLocale) async {
    final locales = await speech.locales();
    String key(String id) => id.replaceAll('-', '_').toLowerCase();
    final system = await speech.systemLocale();
    if (system != null) return system.localeId;
    final prefix = appLocale == AppLocale.ar ? 'ar' : 'en';
    final preferred = appLocale == AppLocale.ar ? 'ar_eg' : 'en_us';
    for (final locale in locales) {
      if (key(locale.localeId) == preferred) return locale.localeId;
    }
    for (final locale in locales) {
      final id = key(locale.localeId);
      if (id == prefix || id.startsWith('${prefix}_')) return locale.localeId;
    }
    return null;
  }

  String _bestTranscript() {
    for (final value in [_liveText, _speech?.lastRecognizedWords ?? '']) {
      final trimmed = value.trim();
      if (trimmed.isNotEmpty) return trimmed;
    }
    return '';
  }

  void _completeTranscript(String words) {
    if (!_listening) return;
    final l10n = context.l10n;
    final transcript = words.trim().isNotEmpty ? words.trim() : _bestTranscript();
    _speech?.stop();
    setState(() {
      _listening = false;
      _expanded = false;
      _liveText = '';
    });
    if (transcript.isEmpty) {
      _showMessage(l10n.voiceEmptyResult);
      return;
    }
    context.push('/transaction/new', extra: parseVoiceEntry(transcript));
  }

  void _finishListen({required String message}) {
    _speech?.stop();
    setState(() {
      _listening = false;
      _expanded = false;
      _liveText = '';
    });
    _showMessage(message);
  }

  void _showMessage(String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.hideCurrentSnackBar();
    messenger?.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final caption = _listening
        ? (_liveText.isEmpty ? l10n.voiceListening : _liveText)
        : null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (caption != null) ...[
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 180.w),
            child: Material(
              color: colors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                child: Text(
                  caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: uiStyle(fontSize: 12, color: colors.onSurface),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
        ],
        if (_expanded) ...[
          _MiniFab(
            key: const Key('add-entry-voice'),
            tooltip: l10n.voiceEntryTooltip,
            icon: TablerIcons.microphone,
            listening: _listening,
            onPressed: _listening ? null : _openVoice,
          ),
          SizedBox(height: 8.h),
          _MiniFab(
            key: const Key('add-entry-manual'),
            tooltip: l10n.manualEntryTooltip,
            icon: TablerIcons.pencil,
            onPressed: _listening ? null : _openManual,
          ),
          SizedBox(height: 8.h),
        ],
        SizedBox(
          width: 56.w,
          height: 56.h,
          child: FloatingActionButton(
            key: const Key('add-transaction-fab'),
            heroTag: 'add-transaction-fab',
            tooltip: l10n.newEntryTooltip,
            onPressed: _toggleMenu,
            child: Icon(
              _expanded ? TablerIcons.x : TablerIcons.plus,
              size: 28.r,
            ),
          ),
        ),
      ],
    );
  }
}

class _MiniFab extends StatelessWidget {
  const _MiniFab({
    super.key,
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.listening = false,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool listening;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      width: 44.w,
      height: 44.h,
      child: FloatingActionButton(
        heroTag: tooltip,
        tooltip: tooltip,
        backgroundColor:
            listening ? colors.primary : colors.primaryContainer,
        onPressed: onPressed,
        child: Icon(icon, size: 22.r),
      ),
    );
  }
}

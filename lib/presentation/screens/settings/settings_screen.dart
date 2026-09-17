import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../theme/colors.dart';
import '../../../theme/typography.dart';
import '../../formatters/currencies.dart';
import '../../widgets/ledgr_app_bar.dart';
import '../../widgets/settings_row.dart';
import 'bloc/settings_bloc.dart';
import 'bloc/settings_event.dart';
import 'bloc/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LedgrAppBar(
        title: 'Settings',
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => context.pop(),
          icon: const Icon(TablerIcons.chevron_left, color: paper, size: 20),
        ),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              SettingsRow(
                key: const Key('settings-currency'),
                icon: TablerIcons.coin,
                label: 'Currency',
                trailing: Text(
                  currencyByCode(state.currencyCode).symbol,
                  style: uiStyle(fontSize: 14, color: mutedInk),
                ),
                onTap: () => _pickCurrency(context, state.currencyCode),
              ),
              SettingsRow(
                key: const Key('settings-categories'),
                icon: TablerIcons.tag,
                label: 'Categories',
                onTap: () => context.push('/categories'),
              ),
              SettingsRow(
                key: const Key('settings-history'),
                icon: TablerIcons.calendar,
                label: 'Transaction history',
                onTap: () => context.push('/history'),
              ),
              SettingsRow(
                key: const Key('settings-sms'),
                icon: TablerIcons.message,
                label: 'Bank SMS Import',
                trailing: state.readyCount > 0
                    ? Text(
                        '${state.readyCount} to review',
                        style: uiStyle(fontSize: 12, color: mutedInk),
                      )
                    : null,
                onTap: () => context.push('/settings/sms'),
              ),
              SettingsRow(
                icon: TablerIcons.chart_bar,
                label: 'Budgets',
                enabled: false,
                trailing: Text(
                  'Coming soon',
                  style: uiStyle(fontSize: 12, color: mutedInk),
                ),
              ),
              SettingsRow(
                icon: TablerIcons.world,
                label: 'Multi-currency',
                enabled: false,
                showDivider: false,
                trailing: Text(
                  'Coming soon',
                  style: uiStyle(fontSize: 12, color: mutedInk),
                ),
              ),
              const SizedBox(height: 32),
              FutureBuilder(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  final version = snapshot.data?.version ?? '1.0.0';
                  final build = snapshot.data?.buildNumber ?? '1';
                  return Text(
                    'Ledgr  $version+$build',
                    textAlign: TextAlign.center,
                    style: uiStyle(fontSize: 13, color: mutedInk),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickCurrency(BuildContext context, String current) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: paper,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text(
                  'Display currency',
                  style: uiStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                'Changes the symbol only — amounts are not converted.',
                style: uiStyle(fontSize: 12, color: mutedInk),
              ),
              const SizedBox(height: 8),
              for (final currency in supportedCurrencies)
                ListTile(
                  title: Text(
                    '${currency.label} (${currency.symbol})',
                    style: uiStyle(fontSize: 14),
                  ),
                  trailing: current == currency.code
                      ? const Icon(TablerIcons.check, color: tealAccent, size: 18)
                      : null,
                  onTap: () => Navigator.pop(context, currency.code),
                ),
            ],
          ),
        );
      },
    );
    if (selected != null && selected != current && context.mounted) {
      context.read<SettingsBloc>().add(SettingsCurrencySelected(selected));
    }
  }
}

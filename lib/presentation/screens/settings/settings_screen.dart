import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/models/app_locale.dart';
import '../../../domain/models/app_theme_mode.dart';
import '../../../domain/models/transaction_type.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';
import '../../formatters/currencies.dart';
import '../../formatters/theme_labels.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/settings_row.dart';
import 'bloc/settings_bloc.dart';
import 'bloc/settings_event.dart';
import 'bloc/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return ListView(
          padding: EdgeInsets.fromLTRB(0.w, 16.h, 0.w, 32.h),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 16.h),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.paperLight,
                  border: Border.all(color: colors.rule),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(width: 3.w, color: colors.ledgerRed),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 16.h),
                          child: Row(
                            children: [
                              Container(
                                width: 48.w,
                                height: 56.h,
                                decoration: BoxDecoration(
                                  color: colors.surfaceContainer,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'L',
                                      style: amountStyle(
                                        fontSize: 24,
                                        color: colors.onSurface,
                                      ),
                                    ),
                                    Text(
                                      l10n.journal,
                                      style: uiStyle(
                                        fontSize: 8,
                                        color: colors.secondary,
                                        letterSpacing:
                                            ltrLetterSpacing(context, 0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            l10n.ledgrJournal,
                                            style: uiStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: colors.onSurface,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 6.w),
                                        FutureBuilder(
                                          future: PackageInfo.fromPlatform(),
                                          builder: (context, snapshot) {
                                            final version =
                                                snapshot.data?.version ??
                                                    '1.0.0';
                                            return Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 6.w,
                                                vertical: 2.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color:
                                                    colors.surfaceContainerHigh,
                                                borderRadius:
                                                    BorderRadius.circular(4.r),
                                              ),
                                              child: Text(
                                                'v$version',
                                                style: uiStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500,
                                                  color: colors.primary,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    Text(
                                      l10n.physicalDriftStorage,
                                      style: uiStyle(
                                        fontSize: 12,
                                        color: colors.secondary,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Wrap(
                                      spacing: 6.w,
                                      runSpacing: 6.h,
                                      children: [
                                        _Chip(
                                          icon: TablerIcons.shield_check,
                                          label: l10n.offlineChip,
                                          color: colors.ledgerGreen,
                                        ),
                                        _Chip(
                                          icon: TablerIcons.cloud_off,
                                          label: l10n.zeroAiChip,
                                          color: colors.secondary,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _SectionHeader(
              title: l10n.activeConfiguration,
              trailing: l10n.localVerified,
            ),
            SettingsRow(
              key: const Key('settings-currency'),
              icon: TablerIcons.coin,
              label: l10n.baseCurrency,
              subtitle: l10n.baseCurrencySubtitle,
              trailing: Text(
                '${currencyByCode(state.currencyCode).symbol} ${state.currencyCode}',
                style: uiStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.primary,
                ),
              ),
              onTap: () => _pickCurrency(context, state.currencyCode),
            ),
            SettingsRow(
              key: const Key('settings-default-type'),
              icon: TablerIcons.arrow_up_right,
              label: l10n.defaultEntryType,
              subtitle: l10n.defaultEntryTypeSubtitle,
              iconColor: colors.ledgerRed,
              iconBackground: colors.errorContainer,
              trailing: _TypeToggle(
                expenseSelected:
                    state.defaultEntryType == TransactionType.expense,
                onChanged: (expense) {
                  context.read<SettingsBloc>().add(
                        SettingsDefaultTypeSelected(
                          expense
                              ? TransactionType.expense
                              : TransactionType.income,
                        ),
                      );
                },
              ),
            ),
            SettingsRow(
              key: const Key('settings-appearance'),
              icon: TablerIcons.moon,
              label: l10n.appearance,
              subtitle: l10n.appearanceSubtitle,
              trailing: Text(
                state.themeMode.localizedLabel(l10n),
                style: uiStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.primary,
                ),
              ),
              onTap: () => _pickTheme(context, state.themeMode),
            ),
            SettingsRow(
              key: const Key('settings-locale'),
              icon: TablerIcons.world,
              label: l10n.language,
              subtitle: l10n.languageSubtitle,
              trailing: _LocaleToggle(
                arabicSelected: state.locale == AppLocale.ar,
                onChanged: (arabic) {
                  context.read<SettingsBloc>().add(
                        SettingsLocaleSelected(
                          arabic ? AppLocale.ar : AppLocale.en,
                        ),
                      );
                },
              ),
            ),
            SettingsRow(
              key: const Key('settings-sms'),
              icon: TablerIcons.message,
              label: l10n.bankSmsImport,
              subtitle: l10n.bankSmsImportSubtitle,
              trailing: state.readyCount > 0
                  ? Text(
                      l10n.readyToReview(state.readyCount),
                      style: uiStyle(fontSize: 12, color: colors.secondary),
                    )
                  : null,
              onTap: () => context.push('/settings/sms'),
            ),
            SizedBox(height: 16.h),
            _SectionHeader(
              title: l10n.upcomingModules,
              trailing: l10n.phase2Plus,
            ),
            SettingsRow(
              icon: TablerIcons.chart_bar,
              label: l10n.categoryBudgets,
              subtitle: l10n.categoryBudgetsSubtitle,
              enabled: false,
              trailing: Text(
                l10n.phase3,
                style: uiStyle(fontSize: 10, color: colors.secondary),
              ),
            ),
            SettingsRow(
              icon: TablerIcons.world,
              label: l10n.multiCurrency,
              subtitle: l10n.multiCurrencySubtitle,
              enabled: false,
              trailing: Text(
                l10n.phase4,
                style: uiStyle(fontSize: 10, color: colors.secondary),
              ),
            ),
            SettingsRow(
              icon: TablerIcons.building_bank,
              label: l10n.vaults,
              subtitle: l10n.vaultsSubtitle,
              enabled: false,
              showDivider: false,
              trailing: Text(
                l10n.phase5,
                style: uiStyle(fontSize: 10, color: colors.secondary),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0.h),
              child: OutlinedButton.icon(
                key: const Key('settings-reset'),
                onPressed: () => _resetLedger(context),
                icon: Icon(TablerIcons.eraser, color: colors.ledgerRed),
                label: Text(
                  l10n.resetLocalLedger,
                  style: uiStyle(
                    fontSize: 16,
                    color: colors.ledgerRed,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: colors.surfaceContainer,
                  side: BorderSide.none,
                  minimumSize: Size.fromHeight(48.h),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(32.w, 28.h, 32.w, 8.h),
              child: Column(
                children: [
                  Container(width: 40.w, height: 2.h, color: colors.rule),
                  SizedBox(height: 12.h),
                  Text(
                    'Ledgr',
                    style: amountStyle(fontSize: 20, color: colors.primary),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    l10n.settingsFooter,
                    textAlign: TextAlign.center,
                    style: uiStyle(fontSize: 12, color: colors.secondary),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickCurrency(BuildContext context, String current) async {
    final colors = context.colors;
    final l10n = context.l10n;
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: colors.paperLight,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
                child: Text(
                  l10n.displayCurrency,
                  style: uiStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colors.onSurface,
                  ),
                ),
              ),
              Text(
                l10n.currencySymbolOnly,
                style: uiStyle(fontSize: 12, color: colors.secondary),
              ),
              SizedBox(height: 8.h),
              for (final currency in supportedCurrencies)
                ListTile(
                  title: Text(
                    '${localizedCurrencyLabel(l10n, currency.code)} (${currency.symbol})',
                    style: uiStyle(fontSize: 14, color: colors.onSurface),
                  ),
                  trailing: current == currency.code
                      ? Icon(TablerIcons.check,
                          color: colors.primary, size: 18.r)
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

  Future<void> _pickTheme(BuildContext context, AppThemeMode current) async {
    final colors = context.colors;
    final l10n = context.l10n;
    final selected = await showModalBottomSheet<AppThemeMode>(
      context: context,
      backgroundColor: colors.paperLight,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final mode in AppThemeMode.values)
                ListTile(
                  title: Text(
                    mode.localizedLabel(l10n),
                    style: uiStyle(fontSize: 14, color: colors.onSurface),
                  ),
                  trailing: current == mode
                      ? Icon(TablerIcons.check,
                          color: colors.primary, size: 18.r)
                      : null,
                  onTap: () => Navigator.pop(context, mode),
                ),
            ],
          ),
        );
      },
    );
    if (selected != null && selected != current && context.mounted) {
      context.read<SettingsBloc>().add(SettingsThemeModeSelected(selected));
    }
  }

  Future<void> _resetLedger(BuildContext context) async {
    final l10n = context.l10n;
    final confirmed = await showDeleteConfirmDialog(
      context: context,
      title: l10n.resetLedgerTitle,
      message: l10n.resetLedgerMessage,
      confirmLabel: l10n.reset,
    );
    if (confirmed && context.mounted) {
      context.read<SettingsBloc>().add(const SettingsResetRequested());
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.trailing});

  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
      color: colors.surfaceContainerLow,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: uiStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: colors.secondary,
                letterSpacing: ltrLetterSpacing(context, 1.0),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            trailing,
            style: uiStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: colors.primaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.r, color: color),
          SizedBox(width: 4.w),
          Text(label, style: uiStyle(fontSize: 10, color: color)),
        ],
      ),
    );
  }
}

class _TypeToggle extends StatelessWidget {
  const _TypeToggle({
    required this.expenseSelected,
    required this.onChanged,
  });

  final bool expenseSelected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Mini(
            label: l10n.debit,
            selected: expenseSelected,
            selectedColor: colors.ledgerRed,
            onTap: () => onChanged(true),
          ),
          _Mini(
            label: l10n.credit,
            selected: !expenseSelected,
            selectedColor: colors.ledgerGreen,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }
}

class _LocaleToggle extends StatelessWidget {
  const _LocaleToggle({
    required this.arabicSelected,
    required this.onChanged,
  });

  final bool arabicSelected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Mini(
            key: const Key('settings-locale-en'),
            label: l10n.localeEn,
            selected: !arabicSelected,
            selectedColor: colors.primary,
            onTap: () => onChanged(false),
          ),
          _Mini(
            key: const Key('settings-locale-ar'),
            label: l10n.localeAr,
            selected: arabicSelected,
            selectedColor: colors.primary,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }
}

class _Mini extends StatelessWidget {
  const _Mini({
    super.key,
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: selected ? selectedColor : Colors.transparent,
          borderRadius: BorderRadius.circular(3.r),
        ),
        child: Text(
          label,
          style: uiStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? colors.paperLight : colors.secondary,
          ),
        ),
      ),
    );
  }
}

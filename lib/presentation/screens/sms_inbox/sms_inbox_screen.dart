import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/models/transaction_type.dart';
import '../../../domain/sms/sms_inbox_item.dart';
import '../../../domain/sms/sms_inbox_status.dart';
import '../../../l10n/l10n.dart';
import '../../formatters/error_labels.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';
import '../../formatters/date_labels.dart';
import '../../formatters/money_format.dart';
import '../../widgets/debit_credit_toggle.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/directional_icon.dart';
import '../../widgets/ledgr_app_bar.dart';
import '../../widgets/ledgr_empty_state.dart';
import '../../widgets/ledgr_primary_button.dart';
import 'bloc/sms_inbox_bloc.dart';
import 'bloc/sms_inbox_event.dart';
import 'bloc/sms_inbox_state.dart';

class SmsInboxScreen extends StatefulWidget {
  const SmsInboxScreen({super.key});

  @override
  State<SmsInboxScreen> createState() => _SmsInboxScreenState();
}

class _SmsInboxScreenState extends State<SmsInboxScreen> {
  late final TextEditingController _paste;

  @override
  void initState() {
    super.initState();
    _paste = TextEditingController();
  }

  @override
  void dispose() {
    _paste.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocConsumer<SmsInboxBloc, SmsInboxState>(
      listenWhen: (previous, current) =>
          (previous.message != current.message && current.message != null) ||
          (previous.flash != current.flash && current.flash != null) ||
          (current.pasteText.isEmpty && previous.pasteText.isNotEmpty),
      listener: (context, state) {
        if (state.pasteText.isEmpty && _paste.text.isNotEmpty) {
          _paste.clear();
        }
        final l10n = context.l10n;
        final text = switch (state.flash) {
          SmsInboxFlash.alreadyInInbox => l10n.alreadyInInbox,
          SmsInboxFlash.noNewBankMessages => l10n.noNewBankMessages,
          SmsInboxFlash.foundMessages =>
            l10n.foundMessagesToReview(state.flashCount ?? 0),
          null => state.message,
        };
        if (text != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(localizedLedgrErrorMessage(l10n, text))),
          );
        }
      },
      builder: (context, state) {
        final bloc = context.read<SmsInboxBloc>();
        final l10n = context.l10n;
        return Scaffold(
          appBar: LedgrAppBar(
            title: l10n.bankSms,
            leading: IconButton(
              tooltip: l10n.back,
              onPressed: () => context.pop(),
              icon: DirectionalIcon(
                TablerIcons.arrow_left,
                color: colors.onSurface,
                size: 22.r,
              ),
            ),
          ),
          body: ListView(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
            children: [
              Text(
                state.inboxSupported
                    ? l10n.smsInboxSupported
                    : l10n.smsInboxUnsupported,
                style:
                    uiStyle(fontSize: 13, color: colors.secondary, height: 1.4),
              ),
              if (state.inboxSupported) ...[
                SizedBox(height: 14.h),
                _PermissionCard(
                  granted: state.hasPermission,
                  scanning: state.scanning,
                  onRequest: () =>
                      bloc.add(const SmsInboxPermissionRequested()),
                  onScan: state.hasPermission
                      ? () => bloc.add(const SmsInboxScanRequested())
                      : null,
                ),
              ],
              SizedBox(height: 18.h),
              TextField(
                key: const Key('sms-paste-field'),
                controller: _paste,
                minLines: 3,
                maxLines: 5,
                style: uiStyle(fontSize: 14, color: colors.onSurface),
                cursorColor: colors.primary,
                decoration: InputDecoration(
                  hintText: l10n.pasteBankSms,
                  hintStyle: uiStyle(fontSize: 14, color: colors.secondary),
                  filled: true,
                  fillColor: colors.paperLight,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colors.rule),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colors.primary),
                  ),
                ),
                onChanged: (value) => bloc.add(SmsInboxPasteChanged(value)),
              ),
              SizedBox(height: 10.h),
              LedgrPrimaryButton(
                key: const Key('sms-parse-button'),
                label: state.parsing ? l10n.parsing : l10n.parse,
                onPressed: state.parsing
                    ? null
                    : () => bloc.add(SmsInboxParseRequested(_paste.text)),
              ),
              SizedBox(height: 20.h),
              FilterSegmentedControl(
                labels: [l10n.toReview, l10n.unmatched, l10n.imported],
                selectedIndex: state.filter.index,
                onSelected: (i) {
                  bloc.add(SmsInboxFilterChanged(SmsInboxFilter.values[i]));
                },
              ),
              SizedBox(height: 12.h),
              if (state.loading)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.h),
                  child: Center(
                    child: CircularProgressIndicator(color: colors.primary),
                  ),
                )
              else if (state.items.isEmpty)
                LedgrEmptyState(message: _emptyMessage(l10n, state.filter))
              else
                ..._rows(context, state.items),
            ],
          ),
        );
      },
    );
  }

  String _emptyMessage(AppLocalizations l10n, SmsInboxFilter filter) {
    switch (filter) {
      case SmsInboxFilter.toReview:
        return l10n.emptyToReview;
      case SmsInboxFilter.unmatched:
        return l10n.emptyUnmatched;
      case SmsInboxFilter.imported:
        return l10n.emptyImported;
    }
  }

  List<Widget> _rows(BuildContext context, List<SmsInboxItem> items) {
    final colors = context.colors;
    return [
      for (var i = 0; i < items.length; i++)
        if (items[i].status == SmsInboxStatus.imported)
          _SmsInboxRow(
            item: items[i],
            showDivider: i != items.length - 1,
            onTap: () => context.push('/settings/sms/${items[i].id}'),
          )
        else
          Dismissible(
            key: ValueKey(items[i].id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: AlignmentDirectional.centerEnd,
              color: colors.ledgerRed,
              padding: EdgeInsetsDirectional.only(end: 16.w),
              child: Icon(
                TablerIcons.trash,
                color: colors.onPrimary,
                size: 20.r,
              ),
            ),
            confirmDismiss: (_) {
              final l10n = context.l10n;
              return showDeleteConfirmDialog(
                context: context,
                title: l10n.skipSmsTitle,
                message: l10n.skipSmsMessage,
                confirmLabel: l10n.skip,
              );
            },
            onDismissed: (_) {
              context
                  .read<SmsInboxBloc>()
                  .add(SmsInboxDismissRequested(items[i].id));
            },
            child: _SmsInboxRow(
              item: items[i],
              showDivider: i != items.length - 1,
              onTap: () => context.push('/settings/sms/${items[i].id}'),
            ),
          ),
    ];
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({
    required this.granted,
    required this.scanning,
    required this.onRequest,
    required this.onScan,
  });

  final bool granted;
  final bool scanning;
  final VoidCallback onRequest;
  final VoidCallback? onScan;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colors.rule),
          bottom: BorderSide(color: colors.rule),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              granted ? l10n.inboxAccessGranted : l10n.allowSmsAccess,
              style: uiStyle(fontSize: 13, color: colors.secondary),
            ),
          ),
          TextButton(
            key: granted
                ? const Key('sms-scan-button')
                : const Key('sms-request-permission'),
            onPressed: granted ? (scanning ? null : onScan) : onRequest,
            child: Text(
              granted
                  ? (scanning ? l10n.scanning : l10n.scanInbox)
                  : l10n.request,
              style: uiStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: colors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmsInboxRow extends StatelessWidget {
  const _SmsInboxRow({
    required this.item,
    required this.showDivider,
    required this.onTap,
  });

  final SmsInboxItem item;
  final bool showDivider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final title = item.note?.trim().isNotEmpty == true
        ? item.note!
        : (item.body.trim().isEmpty
            ? item.sender
            : item.body.trim().split('\n').first);
    final amount = item.amount;
    final type = item.type ?? TransactionType.expense;

    return InkWell(
      key: Key('sms-row-${item.id}'),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          border: showDivider
              ? Border(bottom: BorderSide(color: colors.rule, width: 1.w))
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: uiStyle(fontSize: 14, color: colors.onSurface),
                  ),
                  Text(
                    [
                      if (item.bankId != null) item.bankId!,
                      dateGroupLabel(
                        item.valueDate ?? item.receivedAt,
                        l10n: context.l10n,
                      ),
                    ].join(' · '),
                    style: uiStyle(fontSize: 12, color: colors.secondary),
                  ),
                ],
              ),
            ),
            if (amount != null)
              Text(
                formatSignedAmount(amount, type),
                textAlign: TextAlign.right,
                style: amountStyle(
                  fontSize: 14,
                  color: type == TransactionType.income
                      ? colors.ledgerGreen
                      : colors.ledgerRed,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

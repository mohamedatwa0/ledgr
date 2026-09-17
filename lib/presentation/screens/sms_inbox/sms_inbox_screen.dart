import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/transaction_type.dart';
import '../../../domain/sms/sms_inbox_item.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';
import '../../formatters/date_labels.dart';
import '../../formatters/money_format.dart';
import '../../widgets/debit_credit_toggle.dart';
import '../../widgets/dialogs.dart';
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
    return BlocConsumer<SmsInboxBloc, SmsInboxState>(
      listenWhen: (previous, current) =>
          previous.message != current.message && current.message != null,
      listener: (context, state) {
        if (state.pasteText.isEmpty && _paste.text.isNotEmpty) {
          _paste.clear();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message!)),
        );
      },
      builder: (context, state) {
        final bloc = context.read<SmsInboxBloc>();
        return Scaffold(
          appBar: LedgrAppBar(
            title: 'Bank SMS',
            leading: IconButton(
              tooltip: 'Back',
              onPressed: () => context.pop(),
              icon: const Icon(TablerIcons.chevron_left, color: paper, size: 20),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  children: [
                    Text(
                      state.inboxSupported
                          ? 'Ledgr reads only known bank senders. SMS access is for personal/sideload use — Google Play restricts this permission for expense apps.'
                          : 'Inbox reading isn’t available on this device. Paste a bank SMS below.',
                      style: uiStyle(fontSize: 13, color: mutedInk, height: 1.4),
                    ),
                    if (state.inboxSupported) ...[
                      const SizedBox(height: 14),
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
                    const SizedBox(height: 18),
                    TextField(
                      key: const Key('sms-paste-field'),
                      controller: _paste,
                      minLines: 3,
                      maxLines: 5,
                      style: uiStyle(fontSize: 14),
                      cursorColor: tealAccent,
                      decoration: InputDecoration(
                        hintText: 'Paste a bank SMS',
                        hintStyle: uiStyle(fontSize: 14, color: mutedInk),
                        filled: true,
                        fillColor: paper,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: ruleColor),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: tealAccent),
                        ),
                      ),
                      onChanged: (value) =>
                          bloc.add(SmsInboxPasteChanged(value)),
                    ),
                    const SizedBox(height: 10),
                    LedgrPrimaryButton(
                      key: const Key('sms-parse-button'),
                      label: state.parsing ? 'Parsing…' : 'Parse',
                      onPressed: state.parsing
                          ? null
                          : () => bloc.add(SmsInboxParseRequested(_paste.text)),
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: FilterSegmentedControl(
                        labels: const ['To review', 'Unmatched', 'Imported'],
                        selectedIndex: state.filter.index,
                        onSelected: (i) {
                          bloc.add(
                            SmsInboxFilterChanged(SmsInboxFilter.values[i]),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (state.loading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: CircularProgressIndicator(color: tealAccent),
                        ),
                      )
                    else if (state.items.isEmpty)
                      LedgrEmptyState(message: _emptyMessage(state.filter))
                    else
                      ..._rows(context, state.items),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _emptyMessage(SmsInboxFilter filter) {
    switch (filter) {
      case SmsInboxFilter.toReview:
        return 'Nothing to review — paste a bank SMS or scan the inbox';
      case SmsInboxFilter.unmatched:
        return 'No unmatched messages';
      case SmsInboxFilter.imported:
        return 'No imported SMS yet';
    }
  }

  List<Widget> _rows(BuildContext context, List<SmsInboxItem> items) {
    return [
      for (var i = 0; i < items.length; i++)
        Dismissible(
          key: ValueKey(items[i].id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            color: ledgerRed,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(TablerIcons.trash, color: paper, size: 20),
          ),
          confirmDismiss: (_) {
            return showDeleteConfirmDialog(
              context: context,
              title: 'Skip this SMS?',
              message: 'It will not be added to the ledger.',
              confirmLabel: 'Skip',
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: ruleColor),
          bottom: BorderSide(color: ruleColor),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              granted ? 'Inbox access granted' : 'Allow SMS access to scan bank messages',
              style: uiStyle(fontSize: 13, color: mutedInk),
            ),
          ),
          TextButton(
            key: granted
                ? const Key('sms-scan-button')
                : const Key('sms-request-permission'),
            onPressed: granted
                ? (scanning ? null : onScan)
                : onRequest,
            child: Text(
              granted ? (scanning ? 'Scanning…' : 'Scan inbox') : 'Request',
              style: uiStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: tealAccent,
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
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: showDivider
              ? const Border(bottom: BorderSide(color: ruleColor, width: 1))
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
                    style: uiStyle(fontSize: 14),
                  ),
                  Text(
                    [
                      if (item.bankId != null) item.bankId!,
                      dateGroupLabel(item.valueDate ?? item.receivedAt),
                    ].join(' · '),
                    style: uiStyle(fontSize: 12, color: mutedInk),
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
                  color: type == TransactionType.income ? ledgerGreen : ledgerRed,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

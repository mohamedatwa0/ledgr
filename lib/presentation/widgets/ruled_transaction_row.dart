import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/models/transaction_entry.dart';
import '../../domain/models/transaction_type.dart';
import '../../l10n/l10n.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../formatters/category_labels.dart';
import '../formatters/money_format.dart';
import '../icons/tabler_icon.dart';

class RuledTransactionRow extends StatelessWidget {
  const RuledTransactionRow({
    super.key,
    required this.entry,
    this.showDivider = true,
    this.onTap,
    this.compact = false,
    this.showTime = true,
  });

  final TransactionEntry entry;
  final bool showDivider;
  final VoidCallback? onTap;
  final bool compact;
  final bool showTime;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final isIncome = entry.transaction.type == TransactionType.income;
    final note = entry.transaction.note;
    final title = localizedCategoryName(l10n, entry.category.name);
    final time =
        DateFormat('h:mm a', l10n.localeName).format(entry.transaction.date);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: compact ? 10 : 12,
          horizontal: compact ? 0 : 16,
        ),
        decoration: BoxDecoration(
          color: colors.paperLight,
          border: showDivider
              ? Border(bottom: BorderSide(color: colors.rule, width: 1.w))
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isIncome
                    ? colors.surfaceContainerHighest
                    : colors.secondaryContainer.withValues(alpha: 0.6),
              ),
              child: Icon(
                tablerIcon(entry.category.iconCodePoint),
                size: 18.r,
                color: isIncome ? colors.ledgerGreen : colors.primary,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: uiStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colors.onSurface,
                    ),
                  ),
                  if (note != null && note.isNotEmpty)
                    Text(
                      note,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: uiStyle(fontSize: 12, color: colors.secondary),
                    )
                  else
                    Text(
                      isIncome ? l10n.credit : l10n.debit,
                      style: uiStyle(fontSize: 12, color: colors.secondary),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatSignedAmount(
                    entry.transaction.amount,
                    entry.transaction.type,
                  ),
                  textAlign: TextAlign.right,
                  style: amountStyle(
                    fontSize: 18,
                    color: isIncome ? colors.ledgerGreen : colors.ledgerRed,
                  ),
                ),
                if (showTime)
                  Text(
                    time,
                    style: uiStyle(fontSize: 10, color: colors.secondary),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

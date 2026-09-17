import 'package:flutter/material.dart';

import '../../domain/models/transaction_entry.dart';
import '../../domain/models/transaction_type.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../formatters/money_format.dart';
import '../icons/tabler_icon.dart';

class RuledTransactionRow extends StatelessWidget {
  const RuledTransactionRow({
    super.key,
    required this.entry,
    this.showDivider = true,
    this.onTap,
  });

  final TransactionEntry entry;
  final bool showDivider;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isIncome = entry.transaction.type == TransactionType.income;
    final note = entry.transaction.note;

    return InkWell(
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
            Icon(
              tablerIcon(entry.category.iconCodePoint),
              size: 19,
              color: Color(entry.category.colorValue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.category.name, style: uiStyle(fontSize: 14)),
                  if (note != null)
                    Text(
                      note,
                      style: uiStyle(fontSize: 12, color: mutedInk),
                    ),
                ],
              ),
            ),
            Text(
              formatSignedAmount(
                entry.transaction.amount,
                entry.transaction.type,
              ),
              textAlign: TextAlign.right,
              style: amountStyle(
                fontSize: 14,
                color: isIncome ? ledgerGreen : ledgerRed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

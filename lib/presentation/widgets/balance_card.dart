import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../formatters/date_labels.dart';
import '../formatters/money_format.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.balance,
    required this.credits,
    required this.debits,
    required this.currencyCode,
    required this.month,
    required this.onPreviousMonth,
    required this.onNextMonth,
    this.canGoForward = true,
  });

  final int balance;
  final int credits;
  final int debits;
  final String currencyCode;
  final DateTime month;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final bool canGoForward;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 22),
      child: Stack(
        children: [
          Positioned(
            left: -16,
            top: 2,
            bottom: 2,
            child: Container(width: 3, color: ledgerRed),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    monthPageLabel(month),
                    style: uiStyle(fontSize: 13, color: mutedInk),
                  ),
                  const Spacer(),
                  IconButton(
                    key: const Key('previous-month'),
                    tooltip: 'Previous month',
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    onPressed: onPreviousMonth,
                    icon: const Icon(
                      TablerIcons.chevron_left,
                      size: 18,
                      color: mutedInk,
                    ),
                  ),
                  IconButton(
                    key: const Key('next-month'),
                    tooltip: 'Next month',
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    onPressed: canGoForward ? onNextMonth : null,
                    icon: Icon(
                      TablerIcons.chevron_right,
                      size: 18,
                      color: canGoForward
                          ? mutedInk
                          : mutedInk.withValues(alpha: 0.35),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                formatBalance(balance, currencyCode),
                style: amountStyle(fontSize: 30),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 18,
                runSpacing: 4,
                children: [
                  Text(
                    'Credits ${formatSubtotal(credits)}',
                    style: uiStyle(
                      fontSize: 13,
                      color: ledgerGreen,
                      fontWeight: FontWeight.w400,
                    ).copyWith(fontFeatures: tabularFigures),
                  ),
                  Text(
                    'Debits ${formatSubtotal(debits)}',
                    style: uiStyle(
                      fontSize: 13,
                      color: ledgerRed,
                    ).copyWith(fontFeatures: tabularFigures),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

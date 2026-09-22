import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../l10n/l10n.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../formatters/currencies.dart';
import '../formatters/money_format.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.balance,
    required this.credits,
    required this.debits,
    required this.creditCount,
    required this.debitCount,
    required this.currencyCode,
    required this.month,
    required this.onPreviousMonth,
    required this.onNextMonth,
    this.canGoForward = true,
  });

  final int balance;
  final int credits;
  final int debits;
  final int creditCount;
  final int debitCount;
  final String currencyCode;
  final DateTime month;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final bool canGoForward;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final symbol = currencyByCode(currencyCode).symbol;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.ledgerGreen,
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  l10n.ledgerBook,
                  style: uiStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: colors.secondary,
                    letterSpacing: ltrLetterSpacing(context, 1.4),
                  ),
                ),
              ),
              IconButton(
                key: const Key('previous-month'),
                tooltip: l10n.previousMonth,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(minWidth: 32.w, minHeight: 32.h),
                onPressed: onPreviousMonth,
                icon: Icon(
                  TablerIcons.chevron_left,
                  size: 16.r,
                  color: colors.secondary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: colors.surfaceContainer,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(color: colors.rule),
                ),
                child: Row(
                  children: [
                    Icon(TablerIcons.calendar,
                        size: 14.r, color: colors.primary),
                    SizedBox(width: 4.w),
                    Text(
                      DateFormat('MMM y', l10n.localeName)
                          .format(month)
                          .toUpperCase(),
                      style: uiStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: colors.secondary,
                        letterSpacing: ltrLetterSpacing(context, 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                key: const Key('next-month'),
                tooltip: l10n.nextMonth,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(minWidth: 32.w, minHeight: 32.h),
                onPressed: canGoForward ? onNextMonth : null,
                icon: Icon(
                  TablerIcons.chevron_right,
                  size: 16.r,
                  color: canGoForward
                      ? colors.secondary
                      : colors.secondary.withValues(alpha: 0.35),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          DecoratedBox(
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
                      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.thisMonth,
                            style: uiStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: colors.secondary,
                              letterSpacing: ltrLetterSpacing(context, 1.0),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                symbol,
                                style: amountStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                  color: colors.secondary,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Flexible(
                                child: Text(
                                  formatSubtotal(balance.abs()),
                                  style: amountStyle(
                                    fontSize: 32,
                                    color: colors.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Divider(color: colors.rule, height: 1.h),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: _Subtotal(
                                  label: l10n.credits,
                                  signed: '+${formatSubtotal(credits)}',
                                  countLabel: l10n.depositCount(creditCount),
                                  color: colors.ledgerGreen,
                                  icon: TablerIcons.arrow_up,
                                ),
                              ),
                              Container(
                                width: 1.w,
                                height: 56.h,
                                color: colors.rule.withValues(alpha: 0.6),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: _Subtotal(
                                  label: l10n.debits,
                                  signed: '-${formatSubtotal(debits)}',
                                  hiddenLookup: l10n.hiddenDebitsLookup(
                                    formatSubtotal(debits),
                                  ),
                                  countLabel: l10n.postingCount(debitCount),
                                  color: colors.ledgerRed,
                                  icon: TablerIcons.arrow_down,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Subtotal extends StatelessWidget {
  const _Subtotal({
    required this.label,
    required this.signed,
    required this.countLabel,
    required this.color,
    required this.icon,
    this.hiddenLookup,
  });

  final String label;
  final String signed;
  final String countLabel;
  final Color color;
  final IconData icon;
  final String? hiddenLookup;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16.r, color: color),
            SizedBox(width: 4.w),
            Text(
              label.toUpperCase(),
              style: uiStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: colors.secondary,
                letterSpacing: ltrLetterSpacing(context, 0.8),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Text(signed, style: amountStyle(fontSize: 18, color: color)),
        if (hiddenLookup != null)
          SizedBox(
            height: 0.h,
            child: OverflowBox(
              maxHeight: 1.h,
              child: Text(hiddenLookup!, style: const TextStyle(fontSize: 1)),
            ),
          ),
        Text(
          countLabel,
          style: uiStyle(fontSize: 12, color: colors.secondary),
        ),
      ],
    );
  }
}

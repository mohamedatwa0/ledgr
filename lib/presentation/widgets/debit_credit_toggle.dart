import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../l10n/l10n.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';

class DebitCreditToggle extends StatelessWidget {
  const DebitCreditToggle({
    super.key,
    required this.expenseSelected,
    required this.onChanged,
    this.expanded = false,
  });

  final bool expenseSelected;
  final ValueChanged<bool> onChanged;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
        children: [
          _Segment(
            label: expanded ? l10n.debitExpense : l10n.debit,
            selected: expenseSelected,
            onTap: () => onChanged(true),
            expanded: expanded,
          ),
          _Segment(
            label: expanded ? l10n.creditIncome : l10n.credit,
            selected: !expenseSelected,
            onTap: () => onChanged(false),
            expanded: expanded,
          ),
        ],
      ),
    );
  }
}

class FilterSegmentedControl extends StatelessWidget {
  const FilterSegmentedControl({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            _Segment(
              label: labels[i],
              selected: selectedIndex == i,
              onTap: () => onSelected(i),
              expanded: true,
              pill: false,
            ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
    this.expanded = false,
    this.pill = true,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool expanded;
  final bool pill;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: selected ? colors.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(pill ? 999.r : 8.r),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: uiStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: selected ? colors.onPrimary : colors.secondary,
        ),
      ),
    );
    final tapChild = GestureDetector(onTap: onTap, child: child);
    return expanded ? Expanded(child: tapChild) : tapChild;
  }
}

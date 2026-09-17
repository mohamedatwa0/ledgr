import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/typography.dart';

class DebitCreditToggle extends StatelessWidget {
  const DebitCreditToggle({
    super.key,
    required this.expenseSelected,
    required this.onChanged,
  });

  final bool expenseSelected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Pill(
          label: 'Debit',
          selected: expenseSelected,
          onTap: () => onChanged(true),
        ),
        const SizedBox(width: 10),
        _Pill(
          label: 'Credit',
          selected: !expenseSelected,
          onTap: () => onChanged(false),
        ),
      ],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          _Pill(
            label: labels[i],
            selected: selectedIndex == i,
            onTap: () => onSelected(i),
          ),
        ],
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? tealAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: uiStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? tealOnAccent : mutedInk,
          ),
        ),
      ),
    );
  }
}

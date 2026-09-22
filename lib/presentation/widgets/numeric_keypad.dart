import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors.dart';
import '../../theme/typography.dart';

class NumericKeypad extends StatelessWidget {
  const NumericKeypad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  static const _keys = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '.',
    '0',
    'back',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        mainAxisSpacing: 6.h,
        crossAxisSpacing: 6.w,
        childAspectRatio: 2.2,
        children: [
          for (final key in _keys)
            Material(
              color: colors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(4.r),
              child: InkWell(
                onTap: () {
                  if (key == 'back') {
                    onBackspace();
                  } else {
                    onDigit(key);
                  }
                },
                borderRadius: BorderRadius.circular(4.r),
                child: Center(
                  child: key == 'back'
                      ? Icon(
                          TablerIcons.backspace,
                          size: 20.r,
                          color: colors.ledgerRed,
                        )
                      : Text(
                          key,
                          style: uiStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: colors.onSurface,
                          ),
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

String appendAmountDigit(String current, String digit) {
  if (digit == '.') {
    if (current.contains('.')) return current;
    return current.isEmpty ? '0.' : '$current.';
  }
  if (current == '0') return digit;
  final parts = current.split('.');
  if (parts.length == 2 && parts[1].length >= 2) return current;
  return '$current$digit';
}

String backspaceAmount(String current) {
  if (current.isEmpty) return current;
  return current.substring(0, current.length - 1);
}

String addQuickAmount(String current, int majorUnits) {
  final existing = double.tryParse(current.replaceAll(',', '.')) ?? 0;
  final next = existing + majorUnits;
  if (next == next.roundToDouble()) {
    return next.toInt().toString();
  }
  return next.toStringAsFixed(2);
}

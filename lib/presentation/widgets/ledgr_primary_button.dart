import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors.dart';
import '../../theme/typography.dart';

class LedgrPrimaryButton extends StatelessWidget {
  const LedgrPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onPressed != null;
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor:
              enabled ? colors.primary : colors.primary.withValues(alpha: 0.4),
          foregroundColor: colors.onPrimary,
          disabledBackgroundColor: colors.primary.withValues(alpha: 0.4),
          disabledForegroundColor: colors.onPrimary.withValues(alpha: 0.8),
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          textStyle: uiStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colors.onPrimary,
            letterSpacing: 0.8,
          ),
        ),
        child: Text(label.toUpperCase()),
      ),
    );
  }
}

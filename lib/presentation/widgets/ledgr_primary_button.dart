import 'package:flutter/material.dart';

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
    final enabled = onPressed != null;
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: enabled ? tealAccent : tealAccent.withValues(alpha: 0.4),
          foregroundColor: tealOnAccent,
          disabledBackgroundColor: tealAccent.withValues(alpha: 0.4),
          disabledForegroundColor: tealOnAccent.withValues(alpha: 0.8),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: uiStyle(fontSize: 15, fontWeight: FontWeight.w500, color: tealOnAccent),
        ),
        child: Text(label),
      ),
    );
  }
}

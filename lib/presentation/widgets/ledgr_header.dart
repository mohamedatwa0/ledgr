import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../l10n/l10n.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';

class LedgrHeader extends StatelessWidget {
  const LedgrHeader({
    super.key,
    required this.section,
    this.leading,
    this.actions,
  });

  final String section;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surface.withValues(alpha: 0.92),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 64.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  SizedBox(width: 4.w),
                ],
                Text(
                  'Ledgr',
                  style: amountStyle(
                    fontSize: 24,
                    color: colors.primary,
                    height: 1.2,
                  ),
                ),
                Container(
                  width: 1.w,
                  height: 16.h,
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  color: colors.rule,
                ),
                Expanded(
                  child: Text(
                    section.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: uiStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: colors.secondary,
                      letterSpacing: ltrLetterSpacing(context, 1.2),
                    ),
                  ),
                ),
                if (actions != null) ...actions!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

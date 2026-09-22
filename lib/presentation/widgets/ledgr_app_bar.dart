import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors.dart';
import '../../theme/typography.dart';

class LedgrAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LedgrAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.serifTitle = false,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool serifTitle;

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppBar(
      automaticallyImplyLeading: leading != null,
      leading: leading,
      title: Text(
        title,
        style: serifTitle
            ? amountStyle(fontSize: 20, color: colors.onSurface)
            : uiStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colors.onSurface,
              ),
      ),
      centerTitle: false,
      titleSpacing: leading == null ? 16 : 0,
      actions: actions,
    );
  }
}

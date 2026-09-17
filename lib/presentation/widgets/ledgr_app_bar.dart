import 'package:flutter/material.dart';

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
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: leading != null,
      leading: leading,
      title: Text(
        title,
        style: serifTitle
            ? amountStyle(fontSize: 19, color: paper)
            : uiStyle(fontSize: 14, fontWeight: FontWeight.w500, color: paper),
      ),
      centerTitle: !serifTitle,
      titleSpacing: serifTitle ? 20 : 0,
      actions: actions,
    );
  }
}

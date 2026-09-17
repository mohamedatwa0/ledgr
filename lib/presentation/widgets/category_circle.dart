import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/typography.dart';

class CategoryCircle extends StatelessWidget {
  const CategoryCircle({
    super.key,
    required this.icon,
    required this.label,
    this.selected = false,
    this.iconColor = inkNavy,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: categoryCircleFill,
              border: selected
                  ? Border.all(color: tealAccent, width: 2)
                  : Border.all(color: Colors.transparent, width: 2),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: uiStyle(fontSize: 12, color: mutedInk),
          ),
        ],
      ),
    );
  }
}

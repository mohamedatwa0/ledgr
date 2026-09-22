import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors.dart';
import '../../theme/typography.dart';

class CategoryCircle extends StatelessWidget {
  const CategoryCircle({
    super.key,
    required this.icon,
    required this.label,
    this.selected = false,
    this.iconColor,
    this.onTap,
    this.size = 52,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final Color? iconColor;
  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.categoryCircleFill,
              border: selected
                  ? Border.all(color: colors.primary, width: 2.w)
                  : Border.all(color: Colors.transparent, width: 2.w),
            ),
            child: Icon(
              icon,
              size: size * 0.38,
              color: iconColor ?? colors.onSurface,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: uiStyle(fontSize: 12, color: colors.secondary),
          ),
        ],
      ),
    );
  }
}

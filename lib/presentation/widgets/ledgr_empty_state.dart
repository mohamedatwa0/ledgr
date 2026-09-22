import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors.dart';
import '../../theme/typography.dart';

class LedgrEmptyState extends StatelessWidget {
  const LedgrEmptyState({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 12.w),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: uiStyle(fontSize: 14, color: colors.secondary),
      ),
    );
  }
}

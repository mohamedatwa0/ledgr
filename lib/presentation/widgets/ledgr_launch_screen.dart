import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors.dart';
import '../../theme/typography.dart';

class LedgrLaunchScreen extends StatelessWidget {
  const LedgrLaunchScreen({
    super.key,
    required this.picture,
    required this.pictureSize,
  });

  final ui.Picture? picture;
  final Size pictureSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final side = (MediaQuery.sizeOf(context).shortestSide * 112 / 390)
        .clamp(96.0, 180.0);
    final icon = picture;
    return Scaffold(
      backgroundColor: colors.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              SizedBox(
                width: side,
                height: side,
                child: FittedBox(
                  child: CustomPaint(
                    size: pictureSize,
                    painter: _LedgerIconPainter(icon),
                  ),
                ),
              ),
            SizedBox(height: 32.h),
            Text(
              'Ledgr',
              style: amountStyle(
                fontSize: 40,
                color: dark ? const Color(0xFFF5F3EC) : colors.onSurface,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Simply Track. Simply Know.',
              style: uiStyle(
                fontSize: 16,
                color: dark ? const Color(0xFF8FA0B0) : colors.secondary,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LedgerIconPainter extends CustomPainter {
  const _LedgerIconPainter(this.picture);

  final ui.Picture picture;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPicture(picture);
  }

  @override
  bool shouldRepaint(covariant _LedgerIconPainter oldDelegate) {
    return oldDelegate.picture != picture;
  }
}

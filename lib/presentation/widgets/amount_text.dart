import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/typography.dart';

class AmountText extends StatelessWidget {
  const AmountText({
    super.key,
    required this.text,
    this.fontSize = 14,
    this.color,
    this.textAlign,
  });

  final String text;
  final double fontSize;
  final Color? color;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: amountStyle(
        fontSize: fontSize,
        color: color ?? context.colors.onSurface,
      ),
    );
  }
}

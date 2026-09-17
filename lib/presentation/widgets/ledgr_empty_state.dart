import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/typography.dart';

class LedgrEmptyState extends StatelessWidget {
  const LedgrEmptyState({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 12),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: uiStyle(fontSize: 14, color: mutedInk),
      ),
    );
  }
}

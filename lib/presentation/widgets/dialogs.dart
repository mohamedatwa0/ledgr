import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/typography.dart';

Future<bool> showDeleteConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmLabel = 'Delete',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: paper,
        title: Text(title, style: uiStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        content: Text(message, style: uiStyle(fontSize: 14, color: mutedInk)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: uiStyle(fontSize: 14, color: mutedInk)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              confirmLabel,
              style: uiStyle(fontSize: 14, fontWeight: FontWeight.w500, color: ledgerRed),
            ),
          ),
        ],
      );
    },
  );
  return result ?? false;
}

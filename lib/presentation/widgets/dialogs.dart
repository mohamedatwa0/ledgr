import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';

Future<bool> showDeleteConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? confirmLabel,
}) async {
  final colors = context.colors;
  final l10n = context.l10n;
  final confirm = confirmLabel ?? l10n.delete;
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: colors.paperLight,
        title: Text(
          title,
          style: uiStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: colors.onSurface,
          ),
        ),
        content: Text(
          message,
          style: uiStyle(fontSize: 14, color: colors.secondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              l10n.cancel,
              style: uiStyle(fontSize: 14, color: colors.secondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              confirm,
              style: uiStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colors.ledgerRed,
              ),
            ),
          ),
        ],
      );
    },
  );
  return result ?? false;
}

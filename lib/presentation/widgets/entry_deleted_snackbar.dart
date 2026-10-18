import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../formatters/error_labels.dart';

void showEntryDeletedSnackBar(
  BuildContext context, {
  required VoidCallback onUndo,
}) {
  final l10n = context.l10n;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(l10n.entryDeleted),
        action: SnackBarAction(label: l10n.undo, onPressed: onUndo),
      ),
    );
}

void showLedgerErrorSnackBar(BuildContext context, String message) {
  final l10n = context.l10n;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(localizedLedgrErrorMessage(l10n, message))),
  );
}

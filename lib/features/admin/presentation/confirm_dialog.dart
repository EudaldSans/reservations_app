import 'package:flutter/material.dart';
import 'package:reservations_app/l10n/app_localizations.dart';

/// Asks the admin to confirm a destructive action. Resolves to true only when
/// confirmed.
Future<bool> confirmDestructiveAction(
    BuildContext context, String message) async {
  final l10n = AppLocalizations.of(context);

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.dialogCareful),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(l10n.confirm),
        ),
      ],
    ),
  );

  return confirmed ?? false;
}

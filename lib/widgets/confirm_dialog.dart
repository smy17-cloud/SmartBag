import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Affiche une boîte de dialogue de confirmation générique.
/// Retourne `true` si l'utilisateur confirme, `false` ou `null` sinon.
///
/// Utilisé avant le reset complet des vérifications, pour éviter
/// qu'un appui accidentel n'efface toute la progression du jour.
Future<bool?> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(AppConstants.msgResetCancel),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.colorMissing,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(AppConstants.msgResetConfirmButton),
        ),
      ],
    ),
  );
}

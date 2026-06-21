import 'package:flutter/material.dart';
import '../models/course.dart';
import '../utils/constants.dart';

/// Affiche une seule ligne "cours + statut" dans la liste de l'écran
/// principal. Widget volontairement simple et sans logique métier :
/// il se contente d'afficher l'état qu'on lui donne.
class CourseTile extends StatelessWidget {
  final Course course;

  const CourseTile({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final bool checked = course.isChecked;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        // Liseré coloré à gauche pour un repérage visuel instantané
        border: Border(
          left: BorderSide(
            color: checked
                ? AppConstants.colorPresent
                : AppConstants.colorMissing,
            width: 5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Icône ❌ / ✅
          Icon(
            checked ? Icons.check_circle : Icons.cancel,
            color: checked
                ? AppConstants.colorPresent
                : AppConstants.colorMissing,
            size: 28,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              course.name,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF222222),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

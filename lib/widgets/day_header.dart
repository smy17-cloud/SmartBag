import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Affiche le nom du jour actuel en grand, en haut de l'écran principal.
class DayHeader extends StatelessWidget {
  final int dayOfWeek; // 1 = lundi ... 7 = dimanche

  const DayHeader({super.key, required this.dayOfWeek});

  @override
  Widget build(BuildContext context) {
    final dayName = AppConstants.dayNamesNl[dayOfWeek] ?? '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Text(
        dayName,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Color(0xFF222222),
        ),
      ),
    );
  }
}

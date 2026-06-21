import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schedule_provider.dart';
import '../utils/constants.dart';
import '../widgets/course_tile.dart';
import '../widgets/day_header.dart';
import '../widgets/confirm_dialog.dart';
import 'scanner_screen.dart';
import 'manage_courses_screen.dart';

/// Écran principal de l'application.
/// Affiche le jour actuel, les cours du jour avec leur statut ❌/✅,
/// et les deux actions principales : scanner un livre, tout réinitialiser.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // DateTime.weekday renvoie déjà 1 = lundi ... 7 = dimanche
    final today = DateTime.now().weekday;

    return Scaffold(
      backgroundColor: AppConstants.colorBackground,
      appBar: AppBar(
        title: const Text(
          'Boekentas Check',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppConstants.colorPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: AppConstants.msgManageCourses,
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ManageCoursesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<ScheduleProvider>(
        builder: (context, provider, _) {
          final coursesToday = provider.coursesForDay(today);

          return Column(
            children: [
              DayHeader(dayOfWeek: today),
              Expanded(
                child: coursesToday.isEmpty
                    ? Center(
                        child: Text(
                          AppConstants.msgNoCourseToday,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 12),
                        itemCount: coursesToday.length,
                        itemBuilder: (context, index) {
                          return CourseTile(course: coursesToday[index]);
                        },
                      ),
              ),
              _ActionButtons(provider: provider),
            ],
          );
        },
      ),
    );
  }
}

/// Regroupe les deux boutons d'action du bas d'écran : scanner et reset.
class _ActionButtons extends StatelessWidget {
  final ScheduleProvider provider;

  const _ActionButtons({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: Column(
        children: [
          // Bouton principal : Scanner un livre
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner),
              label: Text(
                AppConstants.msgScanButton,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.colorPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () async {
                // Ouvre l'écran scanner et attend le retour (résultat
                // déjà traité et affiché dans ScannerScreen lui-même).
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ScannerScreen()),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Bouton secondaire : Réinitialiser
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.refresh),
              label: Text(AppConstants.msgResetButton),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppConstants.colorMissing,
                side: BorderSide(color: AppConstants.colorMissing),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () async {
                final confirmed = await showConfirmDialog(
                  context: context,
                  title: AppConstants.msgResetTitle,
                  message: AppConstants.msgResetConfirm,
                );
                if (confirmed == true) {
                  await provider.resetAll();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

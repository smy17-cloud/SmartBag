import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/schedule_provider.dart';
import '../utils/constants.dart';

/// Écran permettant à l'utilisateur de gérer entièrement sa liste de
/// cours : ajouter, modifier, supprimer, et associer un code QR.
class ManageCoursesScreen extends StatelessWidget {
  const ManageCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.colorBackground,
      appBar: AppBar(
        title: Text(AppConstants.msgManageCourses),
        backgroundColor: AppConstants.colorPrimary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ScheduleProvider>(
        builder: (context, provider, _) {
          final courses = [...provider.allCourses]
            ..sort((a, b) {
              final dayCompare = a.dayOfWeek.compareTo(b.dayOfWeek);
              return dayCompare != 0 ? dayCompare : a.name.compareTo(b.name);
            });

          if (courses.isEmpty) {
            return const Center(child: Text('Geen vakken toegevoegd.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    course.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${AppConstants.dayNamesNl[course.dayOfWeek]} · QR: ${course.qrCode}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueGrey),
                        onPressed: () =>
                            _showCourseForm(context, provider, course),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: AppConstants.colorMissing,
                        ),
                        onPressed: () => provider.deleteCourse(course.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppConstants.colorPrimary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Vak toevoegen'),
        onPressed: () {
          final provider = context.read<ScheduleProvider>();
          _showCourseForm(context, provider, null);
        },
      ),
    );
  }

  /// Affiche une feuille modale (bottom sheet) pour ajouter ou modifier
  /// un cours. Si [existing] est null -> mode ajout, sinon mode édition.
  void _showCourseForm(
    BuildContext context,
    ScheduleProvider provider,
    Course? existing,
  ) {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final qrController = TextEditingController(text: existing?.qrCode ?? '');
    int selectedDay = existing?.dayOfWeek ?? 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: StatefulBuilder(
            builder: (ctx, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    existing == null ? 'Vak toevoegen' : 'Vak bewerken',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Naam van het vak',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: qrController,
                    decoration: const InputDecoration(
                      labelText: 'QR-code (bv. wiskunde_001)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    initialValue: selectedDay,
                    decoration: const InputDecoration(
                      labelText: 'Dag',
                      border: OutlineInputBorder(),
                    ),
                    items: AppConstants.dayNamesNl.entries
                        .map(
                          (e) => DropdownMenuItem(
                            value: e.key,
                            child: Text(e.value),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setModalState(() => selectedDay = value);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.colorPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      final name = nameController.text.trim();
                      final qr = qrController.text.trim();
                      if (name.isEmpty || qr.isEmpty) return;

                      if (existing == null) {
                        await provider.addCourse(
                          name: name,
                          qrCode: qr,
                          dayOfWeek: selectedDay,
                        );
                      } else {
                        await provider.editCourse(
                          existing.id,
                          name: name,
                          qrCode: qr,
                          dayOfWeek: selectedDay,
                        );
                      }

                      if (ctx.mounted) Navigator.of(ctx).pop();
                    },
                    child: Text(existing == null ? 'Toevoegen' : 'Opslaan'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

import 'package:hive_flutter/hive_flutter.dart';
import '../models/course.dart';
import 'package:flutter/foundation.dart';
import '../utils/default_courses.dart';

/// Centralise tout l'accès au stockage local (Hive).
///
/// Pourquoi un service séparé plutôt que d'appeler Hive directement
/// depuis le Provider ? Cela respecte le principe de séparation des
/// responsabilités : le Provider gère l'état de l'UI, ce service gère
/// la persistance. Si demain on veut remplacer Hive par autre chose,
/// seul ce fichier change.
class StorageService {
  static const String _boxName = 'coursesBox';

  late Box<Course> _box;

  /// Initialise Hive et ouvre la "box" (équivalent d'une table).
  /// Doit être appelé une seule fois, au démarrage de l'application
  /// (voir main.dart).
  Future<void> init() async {
    await Hive.initFlutter();

    // On enregistre l'adapter seulement s'il ne l'est pas déjà,
    // pour éviter une erreur en cas de hot-reload pendant le dev.
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(CourseAdapter());
    }

    _box = await Hive.openBox<Course>(_boxName);

    // Premier lancement : la box est vide, on insère les cours par défaut.
    if (_box.isEmpty) {
      await _seedDefaultCourses();
    }
  }

  /// Insère la liste de cours par défaut (voir utils/default_courses.dart).
  Future<void> _seedDefaultCourses() async {
    final defaults = defaultCourses();
    for (final course in defaults) {
      await _box.put(course.id, course);
    }
    debugPrint('StorageService: cours par défaut insérés (${defaults.length})');
  }

  /// Retourne tous les cours actuellement enregistrés.
  List<Course> getAllCourses() {
    return _box.values.toList();
  }

  /// Ajoute un nouveau cours ou met à jour un cours existant (même id).
  Future<void> saveCourse(Course course) async {
    await _box.put(course.id, course);
  }

  /// Supprime un cours par son id.
  Future<void> deleteCourse(String id) async {
    await _box.delete(id);
  }

  /// Sauvegarde l'état complet d'un cours déjà présent dans la box
  /// (utilisé après un scan ou un reset, pour persister isChecked).
  Future<void> updateCourse(Course course) async {
    await course.save(); // HiveObject.save() : pratique, pas besoin de l'id
  }
}

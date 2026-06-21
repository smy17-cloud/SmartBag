import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

/// Résultat d'une tentative de scan, utilisé par l'UI pour afficher
/// le bon message (SnackBar) sans dupliquer la logique dans l'écran.
enum ScanResultType { added, alreadyScanned, unknown }

class ScanResult {
  final ScanResultType type;
  final String message;
  ScanResult(this.type, this.message);
}

/// ScheduleProvider est le cœur de l'application : il détient la liste
/// des cours en mémoire, et notifie automatiquement tous les écrans qui
/// l'écoutent (via Consumer/context.watch) dès qu'un changement survient.
///
/// C'est le pattern "Provider" recommandé pour les apps Flutter de
/// taille petite à moyenne : simple à comprendre, peu de boilerplate.
class ScheduleProvider extends ChangeNotifier {
  final StorageService _storageService;

  ScheduleProvider(this._storageService) {
    _loadCourses();
  }

  List<Course> _courses = [];

  /// Liste complète des cours (tous jours confondus).
  List<Course> get allCourses => List.unmodifiable(_courses);

  /// Charge les cours depuis le stockage local au démarrage.
  void _loadCourses() {
    _courses = _storageService.getAllCourses();
    notifyListeners();
  }

  /// Retourne uniquement les cours du jour donné (1 = lundi ... 7 = dimanche).
  List<Course> coursesForDay(int dayOfWeek) {
    return _courses.where((c) => c.dayOfWeek == dayOfWeek).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  /// Traite un code QR scanné. Cette méthode est appelée par ScannerScreen
  /// après chaque détection caméra réussie.
  ///
  /// Logique demandée :
  /// 1. Chercher le cours dont qrCode == code scanné.
  /// 2. Si trouvé et déjà coché -> ne rien changer, message "déjà scanné".
  /// 3. Si trouvé et pas coché -> passer à ✅, sauvegarder, message "ajouté".
  /// 4. Si non trouvé -> message "QR code inconnu".
  Future<ScanResult> handleScan(String scannedCode) async {
    final index = _courses.indexWhere((c) => c.qrCode == scannedCode);

    if (index == -1) {
      return ScanResult(ScanResultType.unknown, AppConstants.msgUnknownQr);
    }

    final course = _courses[index];

    if (course.isChecked) {
      return ScanResult(
        ScanResultType.alreadyScanned,
        AppConstants.msgAlreadyScanned,
      );
    }

    course.isChecked = true;
    await _storageService.updateCourse(course);
    notifyListeners();

    return ScanResult(ScanResultType.added, AppConstants.msgBookAdded);
  }

  /// Remet tous les cours à ❌ (non vérifié). Appelé après confirmation
  /// de l'utilisateur dans la boîte de dialogue (voir confirm_dialog.dart).
  Future<void> resetAll() async {
    for (final course in _courses) {
      course.isChecked = false;
      await _storageService.updateCourse(course);
    }
    notifyListeners();
  }

  // --------------------------------------------------------------------
  // Gestion des cours (ajout / modification / suppression)
  // --------------------------------------------------------------------

  /// Ajoute un nouveau cours. L'id est dérivé du code QR car il est
  /// déjà garanti unique par construction du cahier des charges.
  Future<void> addCourse({
    required String name,
    required String qrCode,
    required int dayOfWeek,
  }) async {
    final course = Course(
      id: qrCode,
      name: name,
      qrCode: qrCode,
      dayOfWeek: dayOfWeek,
      isChecked: false,
    );
    await _storageService.saveCourse(course);
    _courses.add(course);
    notifyListeners();
  }

  /// Met à jour un cours existant (nom, jour ou code QR).
  Future<void> editCourse(
    String id, {
    String? name,
    String? qrCode,
    int? dayOfWeek,
  }) async {
    final course = _courses.firstWhere((c) => c.id == id);
    if (name != null) course.name = name;
    if (qrCode != null) course.qrCode = qrCode;
    if (dayOfWeek != null) course.dayOfWeek = dayOfWeek;
    await _storageService.updateCourse(course);
    notifyListeners();
  }

  /// Supprime un cours définitivement.
  Future<void> deleteCourse(String id) async {
    await _storageService.deleteCourse(id);
    _courses.removeWhere((c) => c.id == id);
    notifyListeners();
  }
}

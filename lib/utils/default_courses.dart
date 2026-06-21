import '../models/course.dart';

/// Données initiales de l'application.
///
/// Cette liste est utilisée UNE SEULE FOIS, la toute première fois que
/// l'application démarre (quand la base Hive est vide). Ensuite, tout
/// passe par le stockage local : l'utilisateur peut ajouter, modifier
/// ou supprimer des cours via l'écran "Vakken beheren".
///
/// Correspondance QR code <-> cours fournie dans le cahier des charges.
/// Les jours sont répartis ici à titre d'exemple ; l'utilisateur pourra
/// les modifier librement ensuite dans l'application.
List<Course> defaultCourses() {
  return [
    Course(
      id: 'wiskunde_001',
      name: 'Wiskunde',
      qrCode: 'wiskunde_001',
      dayOfWeek: 1, // Lundi
      isChecked: false,
    ),
    Course(
      id: 'nederlands_001',
      name: 'Nederlands',
      qrCode: 'nederlands_001',
      dayOfWeek: 1, // Lundi
      isChecked: false,
    ),
    Course(
      id: 'frans_001',
      name: 'Frans',
      qrCode: 'frans_001',
      dayOfWeek: 2, // Mardi
      isChecked: false,
    ),
    Course(
      id: 'aardrijkskunde_001',
      name: 'Aardrijkskunde',
      qrCode: 'aardrijkskunde_001',
      dayOfWeek: 2, // Mardi
      isChecked: false,
    ),
    Course(
      id: 'stem_wetenschap_001',
      name: 'STEM-Wetenschap',
      qrCode: 'stem_wetenschap_001',
      dayOfWeek: 3, // Mercredi
      isChecked: false,
    ),
    Course(
      id: 'wetenschappen_001',
      name: 'Wetenschappen',
      qrCode: 'wetenschappen_001',
      dayOfWeek: 3, // Mercredi
      isChecked: false,
    ),
    Course(
      id: 'engels_001',
      name: 'Engels',
      qrCode: 'engels_001',
      dayOfWeek: 4, // Jeudi
      isChecked: false,
    ),
    Course(
      id: 'geschiedenis_001',
      name: 'Geschiedenis',
      qrCode: 'geschiedenis_001',
      dayOfWeek: 4, // Jeudi
      isChecked: false,
    ),
    Course(
      id: 'godsdienst_001',
      name: 'Godsdienst',
      qrCode: 'godsdienst_001',
      dayOfWeek: 5, // Vendredi
      isChecked: false,
    ),
    Course(
      id: 'techniek_001',
      name: 'Techniek',
      qrCode: 'techniek_001',
      dayOfWeek: 5, // Vendredi
      isChecked: false,
    ),
  ];
}

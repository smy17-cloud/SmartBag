import 'package:hive/hive.dart';

// Cette ligne fait le lien avec le fichier généré automatiquement
// par build_runner (commande expliquée dans le README).
part 'course.g.dart';

/// Représente un cours (et le livre associé) de l'emploi du temps.
///
/// `@HiveType` et `@HiveField` permettent à Hive de sérialiser/désérialiser
/// cet objet automatiquement sans écrire de code de conversion à la main.
@HiveType(typeId: 0)
class Course extends HiveObject {
  /// Identifiant unique du cours (on réutilise le code QR comme id,
  /// car il est déjà unique par construction).
  @HiveField(0)
  String id;

  /// Nom du cours affiché à l'écran (en néerlandais, ex: "Wiskunde").
  @HiveField(1)
  String name;

  /// Code QR attendu pour valider ce cours (ex: "wiskunde_001").
  /// C'est ce texte qui est comparé au résultat du scanner.
  @HiveField(2)
  String qrCode;

  /// Jour de la semaine où ce cours a lieu.
  /// 1 = lundi, 2 = mardi ... 7 = dimanche (norme ISO utilisée par Dart).
  @HiveField(3)
  int dayOfWeek;

  /// Statut actuel : false = ❌ (livre absent), true = ✅ (livre vérifié).
  @HiveField(4)
  bool isChecked;

  Course({
    required this.id,
    required this.name,
    required this.qrCode,
    required this.dayOfWeek,
    this.isChecked = false,
  });
}

import 'package:flutter/material.dart';

/// Toutes les constantes de l'application sont centralisées ici.
/// Cela évite de disperser des couleurs ou des textes "en dur"
/// dans plusieurs fichiers, et facilite une future traduction.
class AppConstants {
  // ----------------------------------------------------------------
  // Couleurs principales (design simple : rouge = absent, vert = présent)
  // ----------------------------------------------------------------
  static const Color colorMissing = Color(0xFFE53935); // rouge
  static const Color colorPresent = Color(0xFF43A047); // vert
  static const Color colorPrimary = Color(0xFF3F51B5); // indigo, couleur d'accent
  static const Color colorBackground = Color(0xFFF5F6FA);

  // ----------------------------------------------------------------
  // Textes affichés à l'utilisateur (en néerlandais, comme demandé
  // pour tout ce qui concerne les cours et le scan)
  // ----------------------------------------------------------------
  static const String msgBookAdded = "Boek toegevoegd aan de boekentas";
  static const String msgUnknownQr = "Onbekende QR-code";
  static const String msgAlreadyScanned = "Dit boek zit al in je boekentas.";
  static const String msgResetTitle = "Alles resetten";
  static const String msgResetConfirm =
      "Weet je zeker dat je alle vakken wilt resetten naar 'niet aanwezig'?";
  static const String msgResetCancel = "Annuleren";
  static const String msgResetConfirmButton = "Resetten";
  static const String msgScanButton = "Scan een boek";
  static const String msgResetButton = "Alles resetten";
  static const String msgManageCourses = "Vakken beheren";
  static const String msgNoCourseToday = "Geen vakken vandaag";

  // Notification quotidienne (texte demandé en néerlandais)
  static const String notificationTitle = "Schoolboeken";
  static const String notificationBody =
      "Controleer je boekentas voor je vertrekt!";

  // ----------------------------------------------------------------
  // Jours de la semaine (1 = lundi ... 7 = dimanche, norme ISO 8601
  // utilisée nativement par DateTime.weekday en Dart)
  // ----------------------------------------------------------------
  static const Map<int, String> dayNamesNl = {
    1: "Maandag",
    2: "Dinsdag",
    3: "Woensdag",
    4: "Donderdag",
    5: "Vrijdag",
    6: "Zaterdag",
    7: "Zondag",
  };
}

# Boekentas Check 📚

Application Flutter permettant aux élèves de vérifier que tous leurs livres
sont dans leur cartable avant les cours, grâce à un scan de QR code collé
sur chaque livre.

## Stack technique

| Composant | Choix |
|---|---|
| Framework | Flutter (Dart) |
| State management | Provider |
| Stockage local | Hive (NoSQL local) |
| Scanner QR | mobile_scanner |
| Notifications | flutter_local_notifications |

## Structure du projet

```
lib/
├── main.dart                     # Point d'entrée, initialisation
├── models/
│   ├── course.dart               # Modèle de données Course
│   └── course.g.dart             # Adapter Hive (sérialisation)
├── providers/
│   └── schedule_provider.dart    # Logique métier : scan, reset, CRUD cours
├── services/
│   ├── storage_service.dart      # Accès Hive
│   └── notification_service.dart # Notification quotidienne
├── screens/
│   ├── home_screen.dart          # Écran principal
│   ├── scanner_screen.dart       # Scan caméra
│   └── manage_courses_screen.dart# Gestion des cours
├── widgets/
│   ├── course_tile.dart
│   ├── day_header.dart
│   └── confirm_dialog.dart
└── utils/
    ├── constants.dart            # Couleurs, textes, jours
    └── default_courses.dart      # Données initiales (10 cours fournis)
```

## Installation et lancement (développement)

### Pré-requis
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installé (canal stable)
- Un appareil Android physique connecté (recommandé, pour tester la caméra)
  ou un émulateur Android avec caméra virtuelle activée
- Android Studio ou VS Code avec l'extension Flutter

### Étapes

```bash
# 1. Se placer dans le dossier du projet
cd cartable_app

# 2. Installer les dépendances
flutter pub get

# 3. (Optionnel) Si tu modifies un champ @HiveField dans models/course.dart,
#    il faut régénérer course.g.dart :
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Lancer l'application sur un appareil/émulateur connecté
flutter run
```

> Le fichier `course.g.dart` est déjà fourni "pré-généré" à la main dans ce
> projet, donc l'étape 3 n'est nécessaire QUE si tu modifies la structure
> du modèle `Course` (ajout/suppression de champ).

## Fonctionnement

1. **Emploi du temps** : 10 cours sont pré-remplis au premier lancement
   (Wiskunde, Nederlands, Frans, Aardrijkskunde, STEM-Wetenschap,
   Wetenschappen, Engels, Geschiedenis, Godsdienst, Techniek), répartis
   sur la semaine. Modifiable entièrement via l'icône ⚙️ en haut à droite.

2. **Scan** : bouton "Scan een boek" → ouvre la caméra → dès qu'un QR code
   est détecté, le texte est comparé aux codes enregistrés :
   - Trouvé + pas encore coché → ✅ + message "Boek toegevoegd aan de boekentas"
   - Trouvé + déjà coché → message "Dit boek zit al in je boekentas." (rien ne change)
   - Pas trouvé → message "Onbekende QR-code"

3. **Reset** : bouton "Alles resetten" → demande confirmation → remet tous
   les cours à ❌.

4. **Notification** : chaque jour à 7h00 (heure modifiable dans
   `main.dart`, fonction `scheduleDailyReminder`), notification
   "Controleer je boekentas voor je vertrekt!".

## Tester avec les QR codes fournis

Les 10 identifiants texte suivants doivent être encodés en QR code
(par exemple via n'importe quel générateur de QR code en ligne, en
choisissant "texte brut" comme contenu) et collés sur les livres :

```
wiskunde_001
nederlands_001
frans_001
aardrijkskunde_001
stem_wetenschap_001
wetenschappen_001
engels_001
geschiedenis_001
godsdienst_001
techniek_001
```

## Publication sur le Play Store

1. **Changer l'identifiant de l'application** dans
   `android/app/build.gradle` : remplacer `com.example.cartable_app`
   par un identifiant unique (ex. `com.tonnom.boekentascheck`).

2. **Générer une clé de signature** (si pas déjà fait) :
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

3. **Créer `android/key.properties`** (ne JAMAIS committer ce fichier) :
   ```
   storePassword=<ton mot de passe>
   keyPassword=<ton mot de passe>
   keyAlias=upload
   storeFile=<chemin vers upload-keystore.jks>
   ```

4. **Adapter `android/app/build.gradle`** pour utiliser cette clé en
   remplaçant la ligne `signingConfig signingConfigs.debug` par une
   vraie configuration de release (voir la
   [documentation officielle Flutter](https://docs.flutter.dev/deployment/android)
   pour le bloc `signingConfigs` complet).

5. **Générer le bundle de production** :
   ```bash
   flutter build appbundle --release
   ```
   Le fichier `.aab` est généré dans
   `build/app/outputs/bundle/release/app-release.aab`, prêt à être
   importé dans la Google Play Console.

6. **Icône de l'application** : remplacer les fichiers dans
   `android/app/src/main/res/mipmap-*/` par tes propres icônes
   (ou utiliser le package `flutter_launcher_icons` pour générer
   automatiquement toutes les résolutions).

## Bonnes pratiques appliquées

- Séparation claire UI / logique métier / persistance (Provider + Service)
- Aucune logique métier dans les widgets (`CourseTile`, `DayHeader` sont
  purement visuels)
- Un seul point de vérité pour les textes et couleurs (`constants.dart`)
- Gestion explicite des permissions runtime (caméra, notifications)
- Code commenté en français pour faciliter la maintenance

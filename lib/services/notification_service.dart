import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../utils/constants.dart';

/// Gère la notification quotidienne qui rappelle à l'élève de vérifier
/// son cartable avant de partir.
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Initialise le plugin de notifications et les fuseaux horaires.
  /// À appeler une seule fois au démarrage de l'app (voir main.dart).
  Future<void> init() async {
    tz_data.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(initSettings);
  }

  /// Demande la permission d'envoyer des notifications (nécessaire
  /// sur Android 13+ / API 33+).
  Future<void> requestPermission() async {
    final androidImpl =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.requestNotificationsPermission();
  }

  /// Programme une notification quotidienne récurrente à l'heure donnée
  /// (par défaut 7h00). Si une notification identique existe déjà,
  /// elle est automatiquement remplacée (même id).
  Future<void> scheduleDailyReminder({
    int hour = 7,
    int minute = 0,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'daily_reminder_channel',
      'Dagelijkse herinnering',
      channelDescription: 'Herinnering om de boekentas te controleren',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      0, // id fixe : une seule notification quotidienne, toujours remplacée
      AppConstants.notificationTitle,
      AppConstants.notificationBody,
      _nextInstanceOfTime(hour, minute),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // répétition quotidienne
    );
  }

  /// Calcule la prochaine occurrence de l'heure donnée (aujourd'hui si
  /// elle n'est pas encore passée, sinon demain).
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  /// Annule la notification quotidienne (utile si l'utilisateur la
  /// désactive depuis les réglages de l'app, fonctionnalité future).
  Future<void> cancelDailyReminder() async {
    await _plugin.cancel(0);
  }
}

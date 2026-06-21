import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'providers/schedule_provider.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';
import 'screens/home_screen.dart';
import 'utils/constants.dart';

Future<void> main() async {
  // Nécessaire car on appelle du code async (Hive, notifications)
  // avant runApp().
  WidgetsFlutterBinding.ensureInitialized();

  // --- Initialisation du stockage local ---
  final storageService = StorageService();
  await storageService.init();

  // --- Initialisation des notifications ---
  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.requestPermission();
  await notificationService.scheduleDailyReminder(hour: 7, minute: 0);

  // --- Demande la permission caméra dès le démarrage ---
  // (on peut aussi la demander plus tard, juste avant d'ouvrir le
  // scanner ; ici on simplifie en la demandant une fois au lancement)
  await Permission.camera.request();

  runApp(CartableApp(storageService: storageService));
}

class CartableApp extends StatelessWidget {
  final StorageService storageService;

  const CartableApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScheduleProvider(storageService),
      child: MaterialApp(
        title: 'Boekentas Check',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppConstants.colorPrimary,
          scaffoldBackgroundColor: AppConstants.colorBackground,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppConstants.colorPrimary,
          ),
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode, debugPrint;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/appwrite_client.dart';
import 'services/auth_service.dart';
import 'auth/auth_wrapper.dart';
import 'audio_service.dart';
import 'audio/bell_service.dart';
import 'services/connectivity_service.dart';
import 'core/app_styles.dart';

// Globaler NavigatorKey, um den Stack bei Login zu bereinigen
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Lifecycle Observer für sauberes Cleanup des AudioService
class _AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (kDebugMode) debugPrint('🔄 App Lifecycle: $state');

    if (state == AppLifecycleState.detached) {
      // App wird geschlossen - AudioService sauber beenden
      if (kDebugMode) {
        debugPrint(
          '🛑 App wird geschlossen - Stoppe AudioService & BellService',
        );
      }
      AudioService().dispose();
      BellService().dispose();
    } else if (state == AppLifecycleState.paused) {
      // App geht in Hintergrund - Audio pausieren (optional)
      if (kDebugMode) debugPrint('⏸️ App in Hintergrund');
    } else if (state == AppLifecycleState.resumed) {
      // App kommt zurück in Vordergrund
      if (kDebugMode) debugPrint('▶️ App in Vordergrund');
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lade .env Konfiguration (Fehlertolerant für Web)
  try {
    await dotenv.load(fileName: ".env");
    if (kDebugMode) debugPrint('✅ .env Datei geladen');
  } catch (e) {
    if (kDebugMode) debugPrint('ℹ️ Keine .env Datei gefunden, nutze Standardwerte');
  }

  // Initialisiere Appwrite Client
  AppwriteClient();

  // Initialisiere Auth-Service und prüfe bestehende Session
  await AuthService().initialize();

  if (kIsWeb) {
    usePathUrlStrategy();
    // Initialisiere Connectivity-Service für Offline-Detection
    ConnectivityService.init();
  }

  // Registriere Lifecycle Observer für sauberes AudioService Cleanup
  WidgetsBinding.instance.addObserver(_AppLifecycleObserver());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MBSR Achtsamkeitstraining',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey, // Key registrieren
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppStyles.bgColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppStyles.primaryOrange,
          background: AppStyles.bgColor,
        ),
        textTheme: GoogleFonts.nunitoTextTheme(),
      ),
      home: const AuthWrapper(),
    );
  }
}

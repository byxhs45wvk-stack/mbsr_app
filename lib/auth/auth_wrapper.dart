import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import '../services/auth_service.dart';
import '../core/appwrite_client.dart';
import '../core/app_config.dart';
import '../splash_screen.dart';
import '../login_screen.dart';
import '../kurs_uebersicht.dart';
import '../pages/home_page.dart';
import '../audio_service.dart';
import '../web_utils.dart' show getCurrentRoute, setRoute;
import '../routing/app_router.dart';

/// Zentrale Authentifizierungs- und Routing-Komponente
/// 
/// Verantwortlichkeiten:
/// - Firebase Auth-Status überwachen
/// - Firestore Rollen-Check (role: 'mbsr')
/// - Deep-Link Routing
/// - Login/Logout Events erkennen
/// - Error-Handling bei Netzwerkproblemen
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _splashFinished = false;
  String? _lastUserId; // Um Login-Events zu erkennen
  bool _isLoginEvent = false; // Flag für frischen Login
  StreamSubscription<models.User?>? _authSubscription;

  @override
  void initState() {
    super.initState();

    // Globaler Listener für Auth-Status (Sicherheitsnetz für Audio)
    _authSubscription = AuthService().authStateChanges.listen((user) {
      if (kDebugMode) {
        debugPrint('AuthWrapper: Status-Update erhalten. User: ${user?.email ?? "ausgeloggt"}');
      }
      if (user == null) {
        if (kDebugMode) {
          debugPrint('👤 Auth-Status: Abgemeldet -> Stoppe AudioService');
        }
        AudioService().stop();
      }
    });

    if (kDebugMode) {
      debugPrint('🚀 AuthWrapper gestartet (Appwrite)');
      debugPrint('📍 Aktuelle Browser-URL: ${Uri.base}');
    }

    // Safety Timeout: Falls der Splash Screen nicht verschwindet
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && !_splashFinished) {
        if (kDebugMode) debugPrint('⚠️ AuthWrapper: Safety Timeout erreicht, erzwinge Splash-Ende');
        setState(() => _splashFinished = true);
      }
    });

    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) setState(() => _splashFinished = true);
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  /// Holt die User-Rolle aus Appwrite Database
  Future<Map<String, dynamic>?> _getUserRole(String email) async {
    try {
      final appwrite = AppwriteClient();
      
      if (kDebugMode) debugPrint('🔍 AuthWrapper: Lade Rolle für $email...');

      // Suche User-Dokument in der users Collection mit 5s Timeout
      final response = await appwrite.databases.listDocuments(
        databaseId: AppConfig.databaseId,
        collectionId: AppConfig.usersCollectionId,
        queries: [
          Query.equal('email', email),
          Query.limit(1),
        ],
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          if (kDebugMode) debugPrint('⚠️ AuthWrapper: Timeout beim Laden der Rolle');
          throw TimeoutException('Rollen-Check dauerte zu lange');
        },
      );

      if (response.documents.isEmpty) {
        if (kDebugMode) debugPrint('⛔ Kein User-Dokument für $email');
        return null;
      }

      final doc = response.documents.first;
      if (kDebugMode) debugPrint('✅ Rolle gefunden: ${doc.data['role']}');
      return doc.data;
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Fehler beim Laden der User-Rolle: $e');
      rethrow;
    }
  }

  /// Bestimmt die Zielseite basierend auf Route und Auth-Status
  Widget _getTargetPage(
    String? route,
    models.User? user,
    String? role, {
    required bool isLoginEvent,
  }) {
    if (kDebugMode) {
      debugPrint(
        '🔍 _getTargetPage - User: ${user?.email ?? "nein"}, Rolle: ${role ?? "nein"}, Route: $route, LoginEvent: $isLoginEvent',
      );
    }

    // Nicht eingeloggt -> Zeige Auswahlseite (MBSRHomePage)
    // ABER: Wenn die Route /login ist, zeige direkt LoginScreen
    if (user == null) {
      if (route == '/login') {
        if (kDebugMode) debugPrint('✅ Navigation: LoginScreen (Route /login)');
        return const LoginScreen();
      }
      if (kDebugMode) {
        debugPrint('✅ Navigation: MBSRHomePage (nicht eingeloggt)');
      }
      return const MBSRHomePage();
    }

    // PRIORITÄT 1: Eingeloggt, aber keine gültige Rolle -> Auswahlseite
    if (role != 'mbsr') {
      if (kDebugMode) debugPrint('⛔ Kein MBSR-Zugriff für ${user.email}');
      AuthService().logout();
      return const MBSRHomePage();
    }

    // PRIORITÄT 2: FRISCHER LOGIN hat absolute Priorität!
    // Nach einem Login IMMER zur Standard-Startseite, egal was in der URL steht
    if (isLoginEvent) {
      if (kDebugMode) {
        debugPrint('🚀 Frischer Login erkannt -> Zeige KursUebersicht');
        debugPrint('🚀 Ignoriere aktuelle Route: $route');
      }

      setRoute('/home'); // URL im Browser synchronisieren

      // Login-Event-Flag SOFORT zurücksetzen (nicht im PostFrameCallback)
      // Verwende Future.microtask für schnelles Reset ohne Build-Konflikt
      Future.microtask(() {
        if (mounted) {
          setState(() {
            _isLoginEvent = false;
            if (kDebugMode) debugPrint('🔄 Login-Event-Flag zurückgesetzt');
          });
        }
      });

      // Gebe KursUebersicht direkt als Root-Widget zurück
      // KEIN Stack-Bereinigung mehr - pushReplacement hat das bereits erledigt
      return const KursUebersicht();
    }

    // PRIORITÄT 3: Wenn URL leer oder /login ist -> Normal zur KursUebersicht
    if (AppRouter.isAuthRoute(route)) {
      if (kDebugMode) {
        debugPrint('✅ Navigation: KursUebersicht (Standard-Route)');
      }
      setRoute(AppRouter.home); // URL im Browser synchronisieren
      return const KursUebersicht();
    }

    // PRIORITÄT 4: Deep-Link Navigation (nur wenn bereits eingeloggt und kein Login-Event)
    if (kDebugMode) debugPrint('🔗 Deep-Link erkannt: $route');
    
    try {
      // Verwende AppRouter für Widget-Auflösung
      final widget = AppRouter.getWidgetForRoute(route);
      
      // Synchronisiere URL
      if (route != null && route.isNotEmpty) {
        setRoute(route);
      }
      
      return widget;
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Fehler bei Navigation: $e');
      setRoute(AppRouter.home);
      return const KursUebersicht();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<models.User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (kDebugMode) {
          debugPrint('AuthWrapper: Status ist ${snapshot.connectionState} (User: ${snapshot.data?.email ?? "null"})');
        }

        if (snapshot.connectionState == ConnectionState.waiting ||
            !_splashFinished) {
          return const SplashScreen();
        }

        final user = snapshot.data;

        // LOGIN-EVENT CHECK: Erkennung eines frischen Logins
        final bool isNewLogin = (_lastUserId == null && user != null);

        if (isNewLogin) {
          if (kDebugMode) {
            debugPrint('🔓 FRISCHER LOGIN erkannt! User: ${user.email}');
            debugPrint('🔓 Setze Login-Event-Flag...');
          }

          // Setze das Login-Event-Flag für _getTargetPage
          // WICHTIG: Setze _lastUserId SOFORT, um mehrfache Trigger zu vermeiden
          _lastUserId = user.$id;
          _isLoginEvent = true;
        } else if (_lastUserId != null && user == null) {
          // Logout erkannt
          _isLoginEvent = false;
          _lastUserId = null;
          if (kDebugMode) {
            debugPrint('🔒 Logout erkannt! Setze Login-Event-Flag zurück...');
          }
        } else {
          // Normaler Build (kein Login/Logout-Event)
          _lastUserId = user?.$id;
        }

        // Route dynamisch auslesen
        String? currentRoute;
        try {
          currentRoute = getCurrentRoute();
          if (kDebugMode) {
            debugPrint('🔗 Aktuelle Route: ${currentRoute ?? "(leer)"}');
          }
        } catch (e) {
          if (kDebugMode) debugPrint('⚠️ Fehler beim Auslesen der Route: $e');
          currentRoute = null;
        }

        if (user == null) {
          return _getTargetPage(currentRoute, null, null, isLoginEvent: false);
        }

        // Hole User-Rolle aus Appwrite Database
        return FutureBuilder<Map<String, dynamic>?>(
          future: _getUserRole(user.email),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }

            // Fehlerbehandlung: Netzwerkprobleme vs. fehlende Daten
            if (roleSnapshot.hasError) {
              // Netzwerkfehler → Zeige Retry-Screen
              return _buildErrorScreen(context);
            }

            // Dokument existiert nicht → User hat keine Berechtigung
            if (!roleSnapshot.hasData || roleSnapshot.data == null) {
              if (kDebugMode) {
                debugPrint('⛔ User ${user.email} hat kein Profil-Dokument');
              }
              AuthService().logout();
              return const MBSRHomePage();
            }

            final role = roleSnapshot.data!['role'] as String?;

            return _getTargetPage(
              currentRoute,
              user,
              role,
              isLoginEvent: _isLoginEvent,
            );
          },
        );
      },
    );
  }

  /// Error-Screen bei Netzwerkproblemen
  Widget _buildErrorScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_off,
                size: 80,
                color: Color(0xFFC97D60),
              ),
              const SizedBox(height: 24),
              const Text(
                'Verbindungsfehler',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B7565),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Bitte prüfe deine Internetverbindung.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: const Color(0xFF8B7565).withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  // Trigger Rebuild → erneuter Versuch
                  setState(() {});
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Erneut versuchen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA68B6F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

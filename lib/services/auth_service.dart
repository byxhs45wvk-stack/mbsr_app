import 'dart:async';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/foundation.dart';
import '../core/appwrite_client.dart';
import '../core/app_config.dart';

/// Authentifizierungs-Service für Appwrite
/// 
/// Security Features:
/// - Session-basierte Authentifizierung
/// - Sichere Logout-Funktionen (einzelne oder alle Sessions)
/// - Stream für Auth-Status-Änderungen
/// - Benutzerfreundliche Fehlermeldungen
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _appwrite = AppwriteClient();
  final _authStateController = StreamController<models.User?>.broadcast();

  /// Stream für Auth-Status (ähnlich wie Firebase authStateChanges)
  /// Emittiert sofort den aktuellen Status beim Abonnieren
  Stream<models.User?> get authStateChanges async* {
    yield _currentUser;
    yield* _authStateController.stream;
  }

  models.User? _currentUser;
  models.User? get currentUser => _currentUser;

  /// Initialisiert den Auth-Service und prüft bestehende Session
  Future<void> initialize() async {
    try {
      if (kDebugMode) debugPrint('🔐 Auth-Service: Prüfe Session...');
      
      // Timeout von 5 Sekunden für die Initialisierung
      final user = await _appwrite.account.get().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          if (kDebugMode) debugPrint('⚠️ Auth-Service: Timeout bei Session-Prüfung');
          throw TimeoutException('Session-Prüfung dauerte zu lange');
        },
      );
      
      _currentUser = user;
      _authStateController.add(user);
      if (kDebugMode) debugPrint('✅ Bestehende Session gefunden: ${user.email}');
    } catch (e) {
      _currentUser = null;
      _authStateController.add(null);
      if (kDebugMode) debugPrint('ℹ️ Keine aktive Session oder Fehler: $e');
    }
  }

  /// Alias für initialize() zur besseren Lesbarkeit
  Future<void> checkSession() => initialize();

  /// Login mit Email und Passwort
  /// 
  /// Wirft [AuthException] bei Fehlern mit benutzerfreundlicher Nachricht
  Future<models.User> login({
    required String email,
    required String password,
  }) async {
    try {
      if (kDebugMode) debugPrint('🔐 Login-Versuch für: $email');

      // Erstelle Email-Password-Session
      await _appwrite.account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      // Hole User-Daten
      final user = await _appwrite.account.get();
      _currentUser = user;
      _authStateController.add(user);

      if (kDebugMode) debugPrint('✅ Login erfolgreich: ${user.email}');
      return user;
    } on AppwriteException catch (e) {
      if (kDebugMode) debugPrint('❌ Login-Fehler: ${e.message}');
      throw AuthException._fromAppwriteException(e);
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Unerwarteter Login-Fehler: $e');
      throw AuthException('Ein unerwarteter Fehler ist aufgetreten.');
    }
  }

  /// Registrierung (Nur für Admin/Migration)
  /// Erstellt Auth-Account UND Datenbank-Eintrag
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    String role = AppConfig.mbsrRole,
  }) async {
    try {
      if (kDebugMode) debugPrint('📝 Erstelle Account für: $email');

      // 1. Auth Account erstellen
      final user = await _appwrite.account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );

      // 2. Datenbank-Dokument erstellen (Nur 3 Felder!)
      await _appwrite.databases.createDocument(
        databaseId: AppConfig.databaseId,
        collectionId: AppConfig.usersCollectionId,
        documentId: ID.unique(),
        data: {
          'email': email,
          'role': role,
          'name': name,
        },
      );

      if (kDebugMode) debugPrint('✅ Account & Profil erfolgreich erstellt');
    } on AppwriteException catch (e) {
      throw AuthException._fromAppwriteException(e);
    }
  }

  /// Logout (beendet aktuelle Session)
  Future<void> logout() async {
    try {
      if (kDebugMode) debugPrint('🔓 Logout...');

      // Lösche aktuelle Session
      await _appwrite.account.deleteSession(sessionId: 'current');

      _currentUser = null;
      _authStateController.add(null);

      if (kDebugMode) debugPrint('✅ Logout erfolgreich');
    } on AppwriteException catch (e) {
      if (kDebugMode) debugPrint('⚠️ Logout-Fehler: ${e.message}');
      // Auch bei Fehler den lokalen State zurücksetzen
      _currentUser = null;
      _authStateController.add(null);
    }
  }

  /// Logout von ALLEN Geräten (löscht alle Sessions)
  /// 
  /// Nützlich bei:
  /// - Passwort-Änderung
  /// - Sicherheitsbedenken
  /// - "Alle Geräte abmelden" Funktion
  Future<void> deleteAllSessions() async {
    try {
      if (kDebugMode) debugPrint('🔓 Lösche alle Sessions...');

      final sessions = await _appwrite.account.listSessions();
      
      for (final session in sessions.sessions) {
        try {
          await _appwrite.account.deleteSession(sessionId: session.$id);
          if (kDebugMode) debugPrint('✅ Session gelöscht: ${session.$id}');
        } catch (e) {
          if (kDebugMode) debugPrint('⚠️ Fehler beim Löschen von Session ${session.$id}: $e');
        }
      }

      _currentUser = null;
      _authStateController.add(null);

      if (kDebugMode) debugPrint('✅ Alle Sessions gelöscht');
    } on AppwriteException catch (e) {
      if (kDebugMode) debugPrint('❌ Fehler beim Löschen aller Sessions: ${e.message}');
      throw AuthException._fromAppwriteException(e);
    }
  }

  /// Passwort-Reset per Email
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      if (kDebugMode) debugPrint('📧 Sende Passwort-Reset-Email an: $email');

      // Appwrite benötigt eine Redirect-URL für den Reset-Link
      // Diese sollte zu deiner App zurückführen
      final redirectUrl =
          'https://byxhs45wvk-stack.github.io/mbsr_app/reset-password';

      await _appwrite.account.createRecovery(
        email: email,
        url: redirectUrl,
      );

      if (kDebugMode) debugPrint('✅ Passwort-Reset-Email gesendet');
    } on AppwriteException catch (e) {
      if (kDebugMode) debugPrint('❌ Fehler beim Senden der Reset-Email: ${e.message}');
      throw AuthException._fromAppwriteException(e);
    }
  }

  /// Hole aktuellen User (refresh)
  Future<models.User?> getCurrentUser() async {
    try {
      final user = await _appwrite.account.get();
      _currentUser = user;
      return user;
    } catch (e) {
      _currentUser = null;
      return null;
    }
  }

  /// Bereinigt Ressourcen
  void dispose() {
    _authStateController.close();
  }
}

/// Custom Exception für benutzerfreundliche Fehlermeldungen
class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  /// Mappt Appwrite-Fehler auf benutzerfreundliche Nachrichten
  factory AuthException._fromAppwriteException(AppwriteException e) {
    // Mappe häufige Fehler-Codes
    switch (e.code) {
      case 401: // Unauthorized
        return AuthException('E-Mail oder Passwort falsch. Bitte prüfe deine Eingabe.');
      case 429: // Too many requests
        return AuthException('Zu viele Fehlversuche. Bitte warte einen Moment.');
      case 500: // Server error
        return AuthException('Server-Fehler. Bitte versuche es später erneut.');
      case 503: // Service unavailable
        return AuthException('Service vorübergehend nicht verfügbar.');
      default:
        // Im Production-Modus keine internen Details preisgeben
        if (kDebugMode) {
          return AuthException('Fehler: ${e.message} (Code: ${e.code})');
        } else {
          return AuthException('Ein Fehler ist aufgetreten. Bitte versuche es erneut.');
        }
    }
  }

  @override
  String toString() => message;
}

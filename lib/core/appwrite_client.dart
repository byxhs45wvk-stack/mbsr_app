import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'app_config.dart';

/// Singleton Appwrite Client
/// 
/// Stellt sicher, dass nur eine Client-Instanz existiert
/// Verhindert Memory-Leaks und Session-Konflikte
class AppwriteClient {
  static final AppwriteClient _instance = AppwriteClient._internal();
  factory AppwriteClient() => _instance;
  AppwriteClient._internal() {
    _initialize();
  }

  late final Client _client;
  late final Account _account;
  late final Databases _databases;
  late final Storage _storage;

  /// Initialisiert den Appwrite Client
  void _initialize() {
    _client = Client()
        .setEndpoint(AppConfig.appwriteEndpoint)
        .setProject(AppConfig.appwriteProjectId);

    // Für Web: Setze selbst-signierte Zertifikate (falls nötig)
    // _client.setSelfSigned(status: true); // Nur für Development!

    _account = Account(_client);
    _databases = Databases(_client);
    _storage = Storage(_client);

    if (kDebugMode) {
      debugPrint('🔧 Appwrite Client initialisiert');
      debugPrint('🔧 Endpoint: ${AppConfig.appwriteEndpoint}');
      debugPrint('🔧 Projekt: ${AppConfig.appwriteProjectId}');
    }
  }

  /// Getter für Services
  Client get client => _client;
  Account get account => _account;
  Databases get databases => _databases;
  Storage get storage => _storage;

  /// Prüft, ob eine aktive Session existiert
  Future<bool> hasActiveSession() async {
    try {
      await _account.get();
      return true;
    } catch (e) {
      return false;
    }
  }
}

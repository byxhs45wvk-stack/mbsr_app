import 'dart:async';
import 'dart:js_interop';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode, debugPrint;
import 'package:web/web.dart' as web;

/// Service zur Überwachung der Internetverbindung
/// 
/// Nutzt Browser-Events (window.onOnline / window.onOffline)
/// um den Verbindungsstatus in Echtzeit zu tracken
/// 
/// Verwendet package:web für moderne Web-Kompatibilität
class ConnectivityService {
  static final _controller = StreamController<bool>.broadcast();
  static bool _isOnline = true;
  static bool _isInitialized = false;

  /// Stream für Verbindungsstatus-Änderungen
  /// true = online, false = offline
  static Stream<bool> get onlineStream => _controller.stream;

  /// Aktueller Verbindungsstatus
  static bool get isOnline => _isOnline;

  /// Initialisiert den Service (nur einmal aufrufen, z.B. in main())
  static void init() {
    if (_isInitialized) return;
    _isInitialized = true;

    if (!kIsWeb) {
      // Für Mobile/Desktop würde hier ein anderes Package verwendet werden
      // Aktuell nur Web-Support
      return;
    }

    try {
      // Initial-Status aus Browser auslesen
      _isOnline = web.window.navigator.onLine;

      // Event-Listener für Online-Status
      web.window.addEventListener('online', ((web.Event event) {
        if (kDebugMode) debugPrint('📶 Internetverbindung wiederhergestellt');
        _isOnline = true;
        _controller.add(true);
      }.toJS));

      // Event-Listener für Offline-Status
      web.window.addEventListener('offline', ((web.Event event) {
        if (kDebugMode) debugPrint('📵 Internetverbindung verloren');
        _isOnline = false;
        _controller.add(false);
      }.toJS));

      if (kDebugMode) {
        debugPrint('📶 ConnectivityService initialisiert (Status: ${_isOnline ? "online" : "offline"})');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('⚠️ ConnectivityService konnte nicht initialisiert werden: $e');
      // Fallback: Annahme, dass wir online sind
      _isOnline = true;
    }
  }

  /// Bereinigt Ressourcen
  static void dispose() {
    _controller.close();
  }
}


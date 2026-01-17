import 'package:flutter/material.dart';
import '../kurs_uebersicht.dart';
import '../literatur_seite.dart';
import '../profil_seite.dart';
import '../login_screen.dart';
import '../pages/home_page.dart';

/// Zentrale Routing-Konfiguration
///
/// Vorteile:
/// - Deklarative Route-Definitionen
/// - Einfaches Hinzufügen neuer Routen
/// - Type-Safe Navigation
/// - Automatische URL-Synchronisation
class AppRouter {
  // Route-Namen als Konstanten (verhindert Tippfehler)
  static const String home = '/home';
  static const String mediathek = '/mediathek';
  static const String vertiefung = '/vertiefung';
  static const String literatur = '/literatur';
  static const String profil = '/profil';
  static const String login = '/login';
  static const String root = '/';

  /// Gibt das Widget für eine Route zurück
  /// Falls Route unbekannt ist, wird KursUebersicht als Fallback zurückgegeben
  static Widget getWidgetForRoute(String? route) {
    if (route == null || route.isEmpty) {
      return const KursUebersicht();
    }

    // Normalisiere Route (entferne führende Slashes wenn doppelt)
    final normalizedRoute = route.startsWith('/') ? route : '/$route';

    // Direkte Widget-Rückgabe ohne WidgetBuilder
    switch (normalizedRoute) {
      case home:
        return const KursUebersicht(initialIndex: 0);
      case mediathek:
        return const KursUebersicht(initialIndex: 1);
      case vertiefung:
        return const KursUebersicht(initialIndex: 2);
      case literatur:
        return LiteraturSeite();
      case profil:
        return const ProfilSeite();
      case login:
        return const LoginScreen();
      case root:
        return const MBSRHomePage();
      default:
        // Fallback zu KursUebersicht
        return const KursUebersicht();
    }
  }

  /// Prüft, ob eine Route eine Login/Auth-Route ist
  static bool isAuthRoute(String? route) {
    return route == login || route == root || route == null || route.isEmpty;
  }

  /// Gibt die Standard-Route nach erfolgreichem Login zurück
  static String getDefaultRouteAfterLogin() => home;

  /// Liste aller verfügbaren Routen (für Debugging)
  static List<String> get availableRoutes => [
    home,
    mediathek,
    vertiefung,
    literatur,
    profil,
    login,
    root,
  ];
}

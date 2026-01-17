import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/services.dart';

/// Liest die aktuelle Route aus der Browser-URL
String? getCurrentRoute() {
  if (!kIsWeb) return null;
  
  try {
    // Verwende Uri.base, um die aktuelle URL inklusive Fragment (Hash) zu lesen
    final uri = Uri.base;
    final hash = uri.fragment;
    
    if (hash.isNotEmpty) {
      final route = hash.startsWith('/') ? hash : '/$hash';
      return route;
    }
    
    final path = uri.path;
    if (path.isNotEmpty && path != '/') {
      return path;
    }
    
    return null;
  } catch (e) {
    return null;
  }
}

/// Setzt die URL im Browser (ohne Reload)
void setRoute(String route) {
  if (!kIsWeb) return;
  
  try {
    // Die sauberste Methode in Flutter, um die Browser-URL zu aktualisieren,
    // ohne den Navigator-Stack zu korrumpieren.
    SystemNavigator.routeInformationUpdated(location: route);
  } catch (e) {
    // Ignoriere Fehler - URL-Update ist optional
  }
}

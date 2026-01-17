import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Helper-Klasse für lokales Tracking von Nutzungsdaten (Privacy First)
/// Speichert lokal in SharedPreferences: "Zuletzt gehört" und Statistiken
class NutzungsTracker {
  /// Gibt die User-ID zurück (email als ID) — wird zum Keying in SharedPreferences verwendet
  static String? get _userId => AuthService().currentUser?.email;

  static String _zuletztGehoertKey(String userId) => 'zuletzt_gehoert_$userId';
  static String _statistikenKey(String userId) => 'statistiken_$userId';

  /// Speichert ein "Zuletzt gehört" Audio lokal (max. 10, neueste zuerst)
  static Future<void> speichereZuletztGehoert(Map<String, String> audio) async {
    final userId = _userId;
    if (userId == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _zuletztGehoertKey(userId);
      final List<String> existing = prefs.getStringList(key) ?? [];

      final entry = jsonEncode({
        'title': audio['title'] ?? '',
        'appwrite_id': audio['appwrite_id'] ?? '',
        'duration': audio['duration'] ?? '',
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Entferne vorhandene mit gleichem Titel
      existing.removeWhere((e) {
        try {
          final m = jsonDecode(e);
          return m['title'] == (audio['title'] ?? '');
        } catch (_) {
          return false;
        }
      });

      existing.insert(0, entry);
      // Halte nur die letzten 10 Einträge
      final trimmed = existing.take(10).toList();
      await prefs.setStringList(key, trimmed);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Fehler beim lokalen Speichern von ZuletztGehoert: $e');
      }
    }
  }

  /// Holt die "Zuletzt gehört" Audios (max. 5) lokal
  static Future<List<Map<String, String>>> getZuletztGehoert() async {
    final userId = _userId;
    if (userId == null) return [];

    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _zuletztGehoertKey(userId);
      final List<String> stored = prefs.getStringList(key) ?? [];
      final List<Map<String, String>> result = [];
      for (var i = 0; i < stored.length && i < 5; i++) {
        try {
          final data = jsonDecode(stored[i]);
          result.add({
            'title': data['title']?.toString() ?? '',
            'appwrite_id': data['appwrite_id']?.toString() ?? '',
            'duration': data['duration']?.toString() ?? '',
          });
        } catch (_) {
          // ignore malformed
        }
      }
      return result;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Fehler beim Laden von lokalem ZuletztGehoert: $e');
      }
      return [];
    }
  }

  /// Speichert Statistiken (z.B. gehörte Dauer) lokal per Datum (additiv)
  static Future<void> speichereStatistik({
    required String audioTitle,
    required int gehoerteSekunden,
  }) async {
    final userId = _userId;
    if (userId == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _statistikenKey(userId);
      final Map<String, dynamic> stats = prefs.getString(key) != null
          ? jsonDecode(prefs.getString(key)!) as Map<String, dynamic>
          : {};

      final today = DateTime.now();
      final String dateKey =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      final current = (stats[dateKey] as int?) ?? 0;
      stats[dateKey] = current + gehoerteSekunden;

      await prefs.setString(key, jsonEncode(stats));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Fehler beim lokalen Speichern der Statistik: $e');
      }
    }
  }

  /// Holt Statistiken (gesamt gehörte Minuten, Lieblingsübung, etc.) lokal
  static Future<Map<String, dynamic>> getStatistiken() async {
    final userId = _userId;
    if (userId == null) {
      return {'gesamtMinuten': 0, 'lieblingsUebung': null, 'anzahlGehoerte': 0};
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _statistikenKey(userId);
      final Map<String, dynamic> stats = prefs.getString(key) != null
          ? jsonDecode(prefs.getString(key)!) as Map<String, dynamic>
          : {};

      int gesamtSekunden = 0;
      stats.forEach((_, value) {
        try {
          gesamtSekunden += (value as int);
        } catch (_) {}
      });

      // Lieblingsübung aus lokalem "Zuletzt gehört" ableiten (vereinfacht)
      final zuletztGehoert = await getZuletztGehoert();
      Map<String, int> uebungHaeufigkeit = {};
      if (zuletztGehoert.isNotEmpty) {
        for (var audio in zuletztGehoert) {
          final title = audio['title'] ?? '';
          uebungHaeufigkeit[title] = (uebungHaeufigkeit[title] ?? 0) + 1;
        }
      }

      String? lieblingsUebung;
      int maxHaeufigkeit = 0;
      uebungHaeufigkeit.forEach((title, haeufigkeit) {
        if (haeufigkeit > maxHaeufigkeit) {
          maxHaeufigkeit = haeufigkeit;
          lieblingsUebung = title;
        }
      });

      // Berechne Wochendaten (letzte 7 Tage)
      final Map<String, int> wochenDaten = {};
      final now = DateTime.now();
      
      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        final dayName = getDayName(date.weekday);
        wochenDaten[dayName] = (stats[dateKey] as int?) ?? 0;
      }

      // Berechne Streak (aufeinanderfolgende Tage mit Praxis)
      int streak = 0;
      for (int i = 0; i < 30; i++) {
        final date = now.subtract(Duration(days: i));
        final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        if ((stats[dateKey] as int?) != null && (stats[dateKey] as int) > 0) {
          streak++;
        } else {
          break; // Streak endet bei erstem Tag ohne Praxis
        }
      }

      // Übungsverteilung in Prozent
      final gesamtUebungen = uebungHaeufigkeit.values.fold(0, (sum, val) => sum + val);
      final Map<String, int> uebungsVerteilung = {};
      if (gesamtUebungen > 0) {
        uebungHaeufigkeit.forEach((title, count) {
          uebungsVerteilung[title] = ((count / gesamtUebungen) * 100).round();
        });
      }

      // Durchschnittliche Sitzungslänge
      final anzahlSitzungen = zuletztGehoert.length;
      final durchschnittsSitzung = anzahlSitzungen > 0 
          ? (gesamtSekunden / 60 / anzahlSitzungen).round() 
          : 0;

      return {
        'gesamtMinuten': (gesamtSekunden / 60).round(),
        'lieblingsUebung': lieblingsUebung,
        'anzahlGehoerte': zuletztGehoert.length,
        'wochenDaten': wochenDaten,
        'streak': streak,
        'uebungsVerteilung': uebungsVerteilung,
        'durchschnittsSitzung': durchschnittsSitzung,
        'laengsteSitzung': 0, // TODO: Wird in Zukunft getrackt
        'kuerzesteSitzung': 0, // TODO: Wird in Zukunft getrackt
      };
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Fehler beim Laden lokaler Statistiken: $e');
      }
      return {
        'gesamtMinuten': 0,
        'lieblingsUebung': null,
        'anzahlGehoerte': 0,
        'wochenDaten': {},
        'streak': 0,
        'uebungsVerteilung': {},
        'durchschnittsSitzung': 0,
        'laengsteSitzung': 0,
        'kuerzesteSitzung': 0,
      };
    }
  }

  /// Hilfsfunktion: Gibt den Wochentag-Namen zurück (öffentlich für Statistik-Seite)
  static String getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Mo';
      case 2: return 'Di';
      case 3: return 'Mi';
      case 4: return 'Do';
      case 5: return 'Fr';
      case 6: return 'Sa';
      case 7: return 'So';
      default: return '';
    }
  }
}

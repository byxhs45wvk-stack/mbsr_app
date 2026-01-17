import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

/// Service für Tempelglocken-Funktionalität
/// 
/// Kann parallel zum Haupt-Audio laufen
/// Ermöglicht:
/// - Glocke am Ende einer Meditation
/// - Glocke in Intervallen (z.B. alle 5 Min)
/// - Glocke als Erinnerung
class BellService {
  // Singleton Pattern
  static final BellService _instance = BellService._internal();
  factory BellService() => _instance;
  BellService._internal();

  AudioPlayer? _bellPlayer;
  Timer? _intervalTimer;

  /// Spielt die Tempelglocke einmalig ab
  /// 
  /// [bellUrl] - URL zur Glocken-Audio-Datei
  /// [volume] - Lautstärke (0.0 - 1.0), default 0.8
  Future<void> playBell({
    required String bellUrl,
    double volume = 0.8,
  }) async {
    try {
      // Erstelle neuen Player, falls noch nicht vorhanden
      _bellPlayer ??= AudioPlayer();

      await _bellPlayer!.setVolume(volume);
      await _bellPlayer!.setUrl(bellUrl);
      await _bellPlayer!.play();

      if (kDebugMode) debugPrint('🔔 Tempelglocke abgespielt');
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Fehler beim Abspielen der Glocke: $e');
    }
  }

  /// Spielt die Glocke nach einer bestimmten Verzögerung
  /// 
  /// [bellUrl] - URL zur Glocken-Audio-Datei
  /// [delay] - Verzögerung bis zum Abspielen
  /// [volume] - Lautstärke (0.0 - 1.0)
  Future<void> scheduleBell({
    required String bellUrl,
    required Duration delay,
    double volume = 0.8,
  }) async {
    if (kDebugMode) {
      debugPrint('🔔 Glocke geplant in ${delay.inMinutes} Min ${delay.inSeconds % 60} Sek');
    }

    _intervalTimer?.cancel();
    _intervalTimer = Timer(delay, () {
      playBell(bellUrl: bellUrl, volume: volume);
    });
  }

  /// Spielt die Glocke in regelmäßigen Intervallen
  /// 
  /// [bellUrl] - URL zur Glocken-Audio-Datei
  /// [interval] - Intervall zwischen Glocken-Schlägen
  /// [volume] - Lautstärke (0.0 - 1.0)
  void startIntervalBell({
    required String bellUrl,
    required Duration interval,
    double volume = 0.8,
  }) {
    if (kDebugMode) {
      debugPrint('🔔 Intervall-Glocke gestartet: alle ${interval.inMinutes} Min');
    }

    _intervalTimer?.cancel();
    _intervalTimer = Timer.periodic(interval, (timer) {
      playBell(bellUrl: bellUrl, volume: volume);
    });
  }

  /// Stoppt alle geplanten Glocken
  void stopScheduledBells() {
    _intervalTimer?.cancel();
    _intervalTimer = null;
    if (kDebugMode) debugPrint('🔔 Geplante Glocken gestoppt');
  }

  /// Stoppt die aktuelle Glocken-Wiedergabe
  Future<void> stopBell() async {
    await _bellPlayer?.stop();
    if (kDebugMode) debugPrint('🔔 Glocke gestoppt');
  }

  /// Bereinigt alle Ressourcen
  void dispose() {
    _intervalTimer?.cancel();
    _bellPlayer?.dispose();
    _bellPlayer = null;
    if (kDebugMode) debugPrint('🔔 BellService disposed');
  }
}

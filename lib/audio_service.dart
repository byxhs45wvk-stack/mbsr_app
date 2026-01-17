import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'nutzungs_tracker.dart';
import 'audio/audio_state.dart';
import 'core/app_config.dart';

// Export AudioServiceStatus für Rückwärtskompatibilität
export 'audio/audio_state.dart' show AudioServiceStatus;

class AudioService {
  // Singleton Pattern
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal() {
    // Globaler Error-Listener für den Player
    _player.playbackEventStream.listen((event) {}, onError: (Object e, StackTrace st) {
      if (kDebugMode) {
        debugPrint('AudioService: Player-Fehler (z.B. Seeking/Netzwerk): $e');
      }
    });
  }

  final AudioPlayer _player = AudioPlayer();
  
  AudioServiceStatus _status = AudioServiceStatus.idle;
  String? _currentAppwriteId;
  String? _currentTitle;
  
  // Streams für die UI
  final _statusController = StreamController<AudioServiceStatus>.broadcast();
  Stream<AudioServiceStatus> get statusStream => _statusController.stream;
  
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  AudioServiceStatus get status => _status;
  String? get currentAppwriteId => _currentAppwriteId;
  String? get currentTitle => _currentTitle;
  Duration get position => _player.position;
  Duration? get duration => _player.duration;
  bool get playing => _player.playing;

  // Letzter Ladezeitpunkt für Debouncing
  DateTime _lastLoadTime = DateTime.fromMillisecondsSinceEpoch(0);
  
  // 80%-Tracking
  Duration? _sessionStartPosition; // Position beim Start der Session
  DateTime? _sessionStartTime; // Zeitpunkt des Session-Starts
  bool _hasTracked80Percent = false; // Verhindert doppeltes Tracking
  StreamSubscription<Duration>? _positionSubscription;

  void _updateStatus(AudioServiceStatus newStatus) {
    _status = newStatus;
    _statusController.add(_status);
  }

  /// Hilfsmethode: Erstellt die Appwrite-URL aus der ID
  String _constructAppwriteUrl(String fileId) {
    return '${AppConfig.appwriteEndpoint}/storage/buckets/${AppConfig.audiosBucketId}/files/$fileId/view?project=${AppConfig.appwriteProjectId}';
  }

  Future<void> play(Map<String, String> audio) async {
    final appwriteId = audio['appwrite_id'];
    final title = audio['title'];
    
    if (appwriteId == null || appwriteId.isEmpty) return;

    final url = _constructAppwriteUrl(appwriteId);

    // Debouncing: 500ms Sperre
    final now = DateTime.now();
    if (now.difference(_lastLoadTime).inMilliseconds < 500) {
      if (kDebugMode) debugPrint("AudioService: Debounce active, ignoring play command.");
      return;
    }
    _lastLoadTime = now;

    // Wenn dasselbe Audio bereits spielt/lädt, mache nichts oder toggel Pause
    if (_currentAppwriteId == appwriteId) {
      if (_player.playing) {
        await pause();
      } else {
        _player.play();
        _updateStatus(AudioServiceStatus.playing);
      }
      return;
    }

    // Statistiken für das VORHERIGE Audio speichern, falls vorhanden
    _saveCurrentStats();

    // Clean Swap: Altes Audio stoppen
    _updateStatus(AudioServiceStatus.loading);
    try {
      await _player.stop();
      
      _currentAppwriteId = appwriteId;
      _currentTitle = title;
      
      // Reset 80%-Tracking für neues Audio
      _hasTracked80Percent = false;
      _sessionStartPosition = null;
      _sessionStartTime = null;

      // Optimierte AudioSource für Appwrite (Unterstützt Seeking & Range Requests)
      final source = AudioSource.uri(
        Uri.parse(url),
        tag: title, // Metadaten für das System
      );

      // Lade Audio mit Preloading für Metadaten
      await _player.setAudioSource(
        source,
        preload: true, // Lädt Metadaten (Dauer) sofort
      );
      
      await _player.play();
      
      _updateStatus(AudioServiceStatus.playing);
      
      // Starte 80%-Tracking
      _startTracking();
      
      // Tracking: Zuletzt gehört speichern
      await NutzungsTracker.speichereZuletztGehoert(audio);
    } catch (e) {
      if (kDebugMode) debugPrint("AudioService Error beim Laden/Abspielen: $e");
      _updateStatus(AudioServiceStatus.error);
      rethrow;
    }
  }

  Future<void> pause() async {
    await _player.pause();
    _updateStatus(AudioServiceStatus.paused);
  }

  Future<void> stop() async {
    _saveCurrentStats();
    await _player.stop();
    _currentAppwriteId = null;
    _currentTitle = null;
    _updateStatus(AudioServiceStatus.idle);
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  /// Startet das 80%-Tracking für das aktuelle Audio
  void _startTracking() {
    _sessionStartPosition = _player.position;
    _sessionStartTime = DateTime.now();
    
    // Cancle vorherige Subscription
    _positionSubscription?.cancel();
    
    // Überwache Position-Stream
    _positionSubscription = _player.positionStream.listen((position) {
      _check80PercentThreshold(position);
    });
  }

  /// Prüft, ob 80% des Audios erreicht wurden
  void _check80PercentThreshold(Duration currentPosition) {
    // Bereits getrackt? Dann nichts tun
    if (_hasTracked80Percent) return;
    
    final totalDuration = _player.duration;
    if (totalDuration == null || totalDuration.inSeconds == 0) return;
    
    // Berechne, ob 80% erreicht wurden
    final threshold = totalDuration.inSeconds * 0.8;
    final currentSeconds = currentPosition.inSeconds;
    
    if (currentSeconds >= threshold) {
      if (kDebugMode) {
        debugPrint('✅ 80%-Schwelle erreicht: $currentSeconds / ${totalDuration.inSeconds} Sekunden');
      }
      
      // Markiere als getrackt
      _hasTracked80Percent = true;
      
      // Speichere in Statistiken (nur die tatsächlich gehörten Sekunden)
      if (_currentTitle != null) {
        // Berechne tatsächliche Hörzeit (nicht die Position im Audio)
        final actualListeningTime = _sessionStartTime != null
            ? DateTime.now().difference(_sessionStartTime!).inSeconds
            : currentSeconds;
        
        // Verhindere unrealistische Werte (z.B. bei schnellem Vorspulen)
        final realisticTime = actualListeningTime > totalDuration.inSeconds
            ? totalDuration.inSeconds
            : actualListeningTime;
        
        if (kDebugMode) {
          debugPrint('📊 Speichere Statistik: $_currentTitle - $realisticTime Sekunden');
        }
        
        NutzungsTracker.speichereStatistik(
          audioTitle: _currentTitle!,
          gehoerteSekunden: realisticTime,
        );
      }
    }
  }

  void _saveCurrentStats() {
    // Diese Methode wird beim Stop/Dispose aufgerufen
    // Wenn 80% noch nicht erreicht wurden, speichern wir NICHTS
    // (verhindert "Fake-Tracking" durch kurzes Anspielen)
    
    if (_hasTracked80Percent) {
      if (kDebugMode) debugPrint('ℹ️ Statistik wurde bereits bei 80% gespeichert');
      return;
    }
    
    // Wenn Audio fast zu Ende ist (>95%), speichern wir trotzdem
    final totalDuration = _player.duration;
    final currentPosition = _player.position;
    
    if (totalDuration != null && 
        currentPosition.inSeconds >= totalDuration.inSeconds * 0.95) {
      if (kDebugMode) debugPrint('✅ Audio fast zu Ende (>95%), speichere Statistik');
      
      if (_currentTitle != null) {
        final actualListeningTime = _sessionStartTime != null
            ? DateTime.now().difference(_sessionStartTime!).inSeconds
            : currentPosition.inSeconds;
        
        NutzungsTracker.speichereStatistik(
          audioTitle: _currentTitle!,
          gehoerteSekunden: actualListeningTime,
        );
      }
    } else {
      if (kDebugMode) {
        debugPrint('ℹ️ Audio wurde nicht weit genug gehört (<80%), keine Statistik gespeichert');
      }
    }
  }

  void dispose() {
    _positionSubscription?.cancel();
    _saveCurrentStats();
    _player.dispose();
    _statusController.close();
  }
}

/// Audio-State-Management
/// 
/// Trennt den Audio-Status von der Business-Logik
/// Ermöglicht einfache Erweiterungen (z.B. Tempelglocke, Timer)

/// Status des Audio-Players
enum AudioServiceStatus {
  idle,     // Kein Audio geladen
  loading,  // Audio wird geladen
  playing,  // Audio spielt
  paused,   // Audio pausiert
  error,    // Fehler beim Laden/Abspielen
}

/// Repräsentiert den aktuellen Zustand eines Audio-Tracks
class AudioState {
  final String? url;
  final String? title;
  final AudioServiceStatus status;
  final Duration position;
  final Duration? duration;
  final String? errorMessage;

  const AudioState({
    this.url,
    this.title,
    this.status = AudioServiceStatus.idle,
    this.position = Duration.zero,
    this.duration,
    this.errorMessage,
  });

  /// Erstellt eine Kopie mit geänderten Werten
  AudioState copyWith({
    String? url,
    String? title,
    AudioServiceStatus? status,
    Duration? position,
    Duration? duration,
    String? errorMessage,
  }) {
    return AudioState(
      url: url ?? this.url,
      title: title ?? this.title,
      status: status ?? this.status,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Leerer State (kein Audio)
  static const AudioState empty = AudioState();

  /// Prüft, ob ein Audio geladen ist
  bool get hasAudio => url != null && url!.isNotEmpty;

  /// Prüft, ob das Audio gerade spielt
  bool get isPlaying => status == AudioServiceStatus.playing;

  /// Prüft, ob das Audio gerade lädt
  bool get isLoading => status == AudioServiceStatus.loading;

  /// Prüft, ob das Audio pausiert ist
  bool get isPaused => status == AudioServiceStatus.paused;

  /// Prüft, ob ein Fehler vorliegt
  bool get hasError => status == AudioServiceStatus.error;

  @override
  String toString() {
    return 'AudioState(url: $url, title: $title, status: $status, position: $position, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AudioState &&
        other.url == url &&
        other.title == title &&
        other.status == status &&
        other.position == position &&
        other.duration == duration;
  }

  @override
  int get hashCode {
    return Object.hash(url, title, status, position, duration);
  }
}

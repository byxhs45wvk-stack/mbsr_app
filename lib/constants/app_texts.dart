/// Zentrale Textverwaltung für die App
/// 
/// Alle User-facing Texte an einem Ort für einfache Anpassungen
/// und Mehrsprachigkeit in der Zukunft
class AppTexts {
  // Tracking-Erklärung
  static const String trackingInfoTitle = 'Über deine Statistiken';
  
  static const String trackingInfoText = 
      'Wir speichern deinen Fortschritt automatisch, sobald du etwa 80% '
      'einer Übung abgeschlossen hast. Dies hilft dir, den Überblick über '
      'deinen MBSR-Kurs zu behalten.\n\n'
      'Ein kurzes Anspielen oder reines Vorspulen wird nicht gewertet, '
      'damit deine Statistik aussagekräftig bleibt.\n\n'
      'Wichtig: Es geht nicht um Leistungskontrolle, sondern um die '
      'Unterstützung deiner Praxis. Auch kleine Schritte sind wertvoll.\n\n'
      '🔒 Datenschutz: Deine Statistiken werden ausschließlich lokal auf '
      'deinem Gerät gespeichert und sind nicht für die Seminarleitung oder '
      'andere Personen zugänglich.';

  // Motivations-Texte
  static const String motivationRegular = 
      'Regelmäßige Praxis ist der Schlüssel';
  
  static const String motivationDescription = 
      'Auch kleine Schritte führen zum Ziel. Deine tägliche Praxis ist '
      'wertvoll, unabhängig von der Dauer.';

  // Streak-Texte
  static const String streakContinue = 'Weiter so!';
  static const String streakStart = 'Starte deine Serie!';
  
  // Offline-Texte
  static const String offlineGeneral = 'Keine Internetverbindung';
  static const String offlineAudio = 'Offline - Audios können nicht geladen werden';
  
  // Error-Texte
  static const String errorConnection = 'Verbindungsfehler';
  static const String errorConnectionDescription = 
      'Bitte prüfe deine Internetverbindung.';
  static const String errorRetry = 'Erneut versuchen';
}

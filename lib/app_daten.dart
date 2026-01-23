/// Zentrale Datenquelle für die gesamte App
/// Diese Datei enthält alle Kursdaten, die sowohl im MBSR-Bereich
/// als auch im Gastbereich verwendet werden
class AppDaten {
  /// Zentrale Mediathek-Daten (Quelle für alle Audios)
  static const List<Map<String, String>> mediathekAudios = [
    {
      'title': 'Ankommen',
      'duration': '3 Min',
      'appwrite_id': '696bfa4c0028c1c9b7b3',
      'description':
          'Eine kurze Übung zum Ankommen im Moment. Ideal zum Einstieg in den Tag oder als Pause zwischendurch.',
    },
    {
      'title': 'Body-Scan (kurz)',
      'duration': '20 Min',
      'appwrite_id': '696bff8a003533170ca4',
      'description':
          'In der kurzen Version des Body-Scans wanderst du zügig durch den Körper. Ideal, um zwischendurch die Verbindung zu dir selbst zu stärken.',
    },
    {
      'title': 'Body-Scan (mittel)',
      'duration': '27 Min',
      'appwrite_id': '696bff9400283154816e',
      'description':
          'Die mittlere Version bietet mehr Raum für das Spüren einzelner Bereiche und das Atmen in den Körper.',
    },
    {
      'title': 'Body-Scan (lang)',
      'duration': '35 Min',
      'appwrite_id': '696bff9b000d16345521',
      'description':
          'Die klassische, ausführliche Übung. Du nimmst dir Zeit für jeden Winkel deines Körpers und entwickelst tiefe Präsenz.',
    },
    {
      'title': 'Sitzmeditation (kurz)',
      'duration': '10 Min',
      'appwrite_id': '696bfa2000a833c13ce',
      'description':
          'In der Sitzmeditation stabilisierst du deine Aufmerksamkeit auf einem primären Objekt (meist der Atembewegung). Wenn der Fokus abschweift – was ein natürlicher Prozess des Gehirns ist – wird dies wertfrei registriert und die Aufmerksamkeit aktiv zum Anker zurückgeführt.',
    },
    {
      'title': 'Sitzmeditation (mittel)',
      'duration': '15 Min',
      'appwrite_id': '696bfaa00090187914b',
      'description':
          'In der Sitzmeditation stabilisierst du deine Aufmerksamkeit auf einem primären Objekt (meist der Atembewegung). Wenn der Fokus abschweift – was ein natürlicher Prozess des Gehirns ist – wird dies wertfrei registriert und die Aufmerksamkeit aktiv zum Anker zurückgeführt.',
    },
    {
      'title': 'Sitzmeditation (lang)',
      'duration': '20 Min',
      'appwrite_id': '696bffb000325d0acc84',
      'description':
          'In der Sitzmeditation stabilisierst du deine Aufmerksamkeit auf einem primären Objekt (meist der Atembewegung). Wenn der Fokus abschweift – was ein natürlicher Prozess des Gehirns ist – wird dies wertfrei registriert und die Aufmerksamkeit aktiv zum Anker zurückgeführt.',
    },
    {
      'title': 'Achtsamkeit in Bewegung',
      'duration': '20 Min',
      'appwrite_id': '696bffb90034f23257c2',
      'description':
          'Diese Übung kombiniert langsame Bewegungen mit kontinuierlicher Aufmerksamkeit. Du trainierst, die Signale deines Bewegungsapparates (Dehnung, Kraft, Gleichgewicht) in Aktion zu beobachten. Dabei lernst du, auch während körperlicher Anstrengung die begleitenden Gedanken und Bewertungen wahrzunehmen.',
    },
    {
      'title': 'Mitgefühl',
      'duration': '12 Min',
      'appwrite_id': '696bffcc000a9fa2ce09',
      'description':
          'Die Metta-Meditation stärkt die liebevolle Güte dir selbst und anderen gegenüber. Besonders wertvoll für das Wohlbefinden.',
    },
    {
      'title': 'Tour der Sinne',
      'duration': '10 Min',
      'appwrite_id': '696bffd600298b5e9c51',
      'description':
          'Erforsche die Welt durch deine Sinne – Hören, Spüren, Riechen. Eine Einladung, die Welt ganz neu wahrzunehmen.',
    },
  ];

  // Alle Wochen-Daten (Audios entfernt, nur PDFs und Aufgaben)
  static const List<Map<String, dynamic>> wochenDaten = [
    {
      'n': '1',
      't': 'Was ist Achtsamkeit (nicht)?',
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 1',
          'appwrite_id': '696bfa6b0039f0497205',
        },
      ],
      'wochenAufgaben': [
        '1.	Body-Scan mehrmals pro Woche mit Audiodatei üben.',
        '2.	Eine Mahlzeit in dieser Woche achtsam einnehmen.',
        '3.	Die Neun-Punkte-Übung bearbeiten.',
        '4.	Die Geschichte vom Oberfluss und Unterfluss lesen.',
      ],
    },
    {
      'n': '2',
      't': 'Wie wir die Welt wahrnehmen',
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 2',
          'appwrite_id': '696bfc7f003e17db0a1e',
        },
      ],
      'wochenAufgaben': [
        '1.	Body-Scan mit Audiodatei mehrmals pro Woche üben.',
        '2.	Eine alltägliche Tätigkeit mit Anfängergeist ausführen (z. B. Zähneputzen, Duschen, Geschirrspülen).',
        '3.	Möglichst täglich für einige Minuten die Aufmerksamkeit auf den Atem richten.',
        '4.	Den Kalender der angenehmen Erlebnisse nutzen.',
      ],
    },
    {
      'n': '3',
      't': 'Im Körper beheimatet sein',
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 3',
          'appwrite_id': '696bfc8c001ab2d0d7fb',
        },
      ],
      'wochenAufgaben': [
        '1.	Mehrmals pro Woche Body-Scan oder achtsame Körperarbeit üben.',
        '2.	Möglichst täglich den Atem im Alltag beobachten.',
        '3.	Den Kalender der unangenehmen Erlebnisse ausfüllen.',
      ],
    },
    {
      'n': '4',
      't': 'Dem Stress auf der Spur',
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 4',
          'appwrite_id': '696bfd3d00077e7e2c0b',
        },
      ],
      'wochenAufgaben': [
        '1.	Regelmäßige formelle Praxis (Body-Scan, Körperarbeit oder Sitzmeditation).',
        '2.	Atembeobachtung im Alltag.',
        '3.	Abschnitt „Achtsamkeit am Arbeitsplatz“ lesen.',
        '4.	Stressreaktionen notieren.',
      ],
    },
    {
      'n': '5',
      't': 'Achtsamkeit und ihre Wirkungsweise',
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 5',
          'appwrite_id': '696bfd450038aba59bcf',
        },
      ],
      'wochenAufgaben': [
        '1.	Sitzmeditation üben, im Wechsel mit Body-Scan oder Körperarbeit.',
        '2.	Achtsamkeit in stressigen Situationen anwenden.',
        '3.	Kalender der „Schwierigen Kommunikation“ ausfüllen.',
      ],
    },
    {
      'n': '6',
      't': 'Schwierige Kommunikation',
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 6',
          'appwrite_id': '696bfd4f0037e7e16a9f',
        },
      ],
      'wochenAufgaben': [
        '1. Sitzmeditation üben, im Wechsel mit Body-Scan oder Körperarbeit.',
        '2.	Reaktionen in zwischenmenschlichen Situationen beobachten.',
        '3.	Sinneseindrücke bewusst wahrnehmen.',
      ],
    },
    {
      'n': '7',
      't': 'Selbstfürsorge',
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 7',
          'appwrite_id': '696bfd57000f4bb29d10',
        },
      ],
      'wochenAufgaben': [
        '1.	Übungen ohne Anleitung praktizieren.',
        '2.	Reflexion über das Kursende und die Fortführung der Praxis.',
        '3.	Unterscheidung zwischen Wahrnehmung und Interpretation üben.',
      ],
    },
    {
      'n': '8',
      't': 'Rückschau und Ausblick',
      'pdfs': [
        {
          'title': 'Kursunterlagen Woche 8',
          'appwrite_id': '696bfd5f002394219efb',
        },
      ],
      'wochenAufgaben': [
        '1. Eigene Praxis dauerhaft im Alltag verankern.',
        '2. Rückblick auf die 8 Wochen.',
        '3. Dankbarkeitspraxis kultivieren.',
        '4. Stille Meditation praktizieren.',
      ],
    },
  ];

  static const Map<String, dynamic> tagDerAchtsamkeit = {
    'titel': 'Tag der Achtsamkeit',
    'beschreibung': 'Ein spezieller Tag für Kursteilnehmer und Ehemalige.',
    'pdfs': [
      {
        'title': 'Ablaufplan Praxistag',
        'appwrite_id': '696c0000000000000008', // Platzhalter ID
      },
    ],
  };

  /// Gibt alle Audios aus der zentralen Mediathek zurück
  static List<Map<String, String>> getAlleAudios() {
    return mediathekAudios;
  }

  static const List<Map<String, String>> zusatzUebungen = [];
}

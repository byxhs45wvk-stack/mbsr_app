# Snyk Scan - Erklärung: Android Dependencies

## Was bedeutet "Android Dependencies scannen"?

Flutter Apps haben **zwei Arten von Dependencies**:

### 1️⃣ Dart/Flutter Pub Dependencies (in `pubspec.yaml`)
Das sind die **Flutter/Dart Packages**, die du direkt verwendest:
- `firebase_core`, `firebase_auth`, `cloud_firestore`
- `just_audio`, `url_launcher`
- `shared_preferences`, `google_fonts`
- etc.

**Diese werden immer gescannt** ✅ (schnell, kein Build nötig)

### 2️⃣ Native Android Dependencies (in `android/app/build.gradle.kts`)
Das sind die **Java/Kotlin Libraries**, die Flutter Plugins intern nutzen:
- Google Services (Firebase SDK)
- Android Support Libraries
- Native Bibliotheken für Audio, Network, etc.

**Diese zu scannen ist optional** ⚠️ (benötigt Android Build)

## Warum wird gefragt?

### Vorteile von Android-Scan:
✅ **Vollständiger Scan** - Findet auch Sicherheitslücken in nativen Libraries
✅ **Umfassende Sicherheit** - Prüft alle Dependencies, die deine App verwendet
✅ **Besser für Production** - Alle Ebenen werden geprüft

### Nachteile von Android-Scan:
⚠️ **Braucht Zeit** - App muss erst gebaut werden (1-5 Minuten)
⚠️ **Benötigt Android SDK** - Android SDK muss installiert sein
⚠️ **Kann fehlschlagen** - Wenn Android Setup nicht vollständig ist

## Was passiert bei der Nachfrage?

### Wenn du "j" (ja) antwortest:
1. 🔨 Flutter App wird für Android gebaut (`flutter build apk --debug`)
2. ⏳ Das dauert 1-5 Minuten
3. 🔍 Android Gradle Dependencies werden gescannt
4. 📊 Du erhältst zusätzliche Ergebnisse für native Libraries

### Wenn du "n" (nein) antwortest:
1. ⏭️ Android-Scan wird übersprungen
2. ✅ Nur Dart/Flutter Pub Dependencies werden gescannt (das ist meist ausreichend!)
3. ⚡ Schneller und einfacher

## Empfehlung

**Für den Start:** Antwort "n" (nein) wählen
- Nur Pub Dependencies scannen reicht meist aus
- Schneller und einfacher
- Die meisten Sicherheitslücken sind in Pub Dependencies

**Für Production/Releases:** Antwort "j" (ja) wählen
- Vollständiger Scan aller Dependencies
- Sicherer für veröffentlichte Apps
- Findet auch Probleme in nativen Libraries

## Beispiel-Ablauf

```
🔍 Snyk Security Scan - Komplett wird gestartet...
📦 Flutter Dependencies werden installiert...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1️⃣  SCAN: Dart/Flutter Pub Dependencies
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Testing /path/to/app...
✓ No known vulnerabilities found
[Scan läuft durch...]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
2️⃣  SCAN: Android Gradle Dependencies (optional)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📱 Android Build-Datei gefunden. Möchtest du Android Dependencies scannen? (j/n)
> n                                    ← Du antwortest "n"

⏭️  Android-Scan übersprungen

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 SCAN ABGESCHLOSSEN!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Vereinfachtes Script (ohne Nachfrage)

Wenn du die Nachfrage umgehen willst, kannst du `snyk-scan.sh` verwenden:

```bash
./snyk-scan.sh  # Scannt nur Pub Dependencies, keine Nachfrage
```

Oder manuell:
```bash
snyk test --file=pubspec.yaml --package-manager=pkg:pub
```

## Zusammenfassung

| Frage | Antwort | Ergebnis |
|-------|---------|----------|
| **"Möchtest du Android Dependencies scannen?"** | **j** (ja) | Scannt Pub + Android Dependencies (vollständig, aber langsamer) |
| | **n** (nein) | Scannt nur Pub Dependencies (schnell, meist ausreichend) ✅ |

**Empfehlung:** Für den ersten Scan einfach **"n"** antworten. Das ist schneller und reicht meist vollkommen aus! 🎯

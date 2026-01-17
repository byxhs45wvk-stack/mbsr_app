# Snyk Security Integration - Setup-Anleitung

Diese Anleitung hilft dir dabei, Snyk Security in deinem Flutter-Projekt zu integrieren.

## Was ist Snyk?

Snyk ist ein Sicherheits-Tool, das deine Dependencies (in diesem Fall Flutter/Dart Packages) auf bekannte Sicherheitslücken überprüft.

## Setup-Optionen

### Option 1: GitHub Actions (Empfohlen)

Diese Option scannt automatisch bei jedem Push und Pull Request.

#### Schritt 1: Snyk Account erstellen

1. Gehe zu [snyk.io](https://snyk.io) und erstelle einen kostenlosen Account
2. Aktiviere GitHub Integration (optional, aber empfohlen)

#### Schritt 2: Snyk Token erstellen

1. Logge dich bei Snyk ein
2. Gehe zu Settings → Account → Auth Token
3. Erstelle einen neuen Token (oder verwende einen bestehenden)
4. Kopiere den Token

#### Schritt 3: GitHub Secret hinzufügen

1. Gehe zu deinem GitHub Repository
2. Settings → Secrets and variables → Actions
3. Klicke "New repository secret"
4. Name: `SNYK_TOKEN`
5. Value: Dein Snyk Token
6. Klicke "Add secret"

#### Schritt 4: GitHub Actions aktivieren

Die Datei `.github/workflows/snyk-security.yml` wurde bereits erstellt. Sie wird automatisch ausgeführt, wenn du:
- Code zu main/master/develop pusht
- Pull Requests erstellst
- Manuell über "Actions" → "Run workflow" auslöst

### Option 2: Lokale Installation (Für manuelle Scans)

#### Schritt 1: Snyk CLI installieren

**Mit npm (empfohlen):**
```bash
npm install -g snyk
```

**Mit Homebrew (macOS):**
```bash
brew tap snyk/tap
brew install snyk
```

**Mit Scoop (Windows):**
```bash
scoop bucket add snyk https://github.com/snyk/scoop-snyk.git
scoop install snyk
```

#### Schritt 2: Snyk authentifizieren

```bash
snyk auth
```

Dies öffnet deinen Browser zur Authentifizierung.

#### Schritt 3: Ersten Scan durchführen

**Wichtig:** Snyk verwendet `pkg:pub` als Package Manager (nicht `dart`)!

```bash
# Test-Scan für Dart/Flutter Pub Dependencies (zeigt Probleme an, bricht aber nicht ab)
snyk test --file=pubspec.yaml --package-manager=pkg:pub

# Detaillierter Scan mit Bericht
snyk test --file=pubspec.yaml --package-manager=pkg:pub --json > snyk-report.json

# Monitor-Modus (speichert Ergebnisse in Snyk Dashboard)
snyk monitor --file=pubspec.yaml --package-manager=pkg:pub

# Mit Severity-Threshold (nur High/Critical)
snyk test --file=pubspec.yaml --package-manager=pkg:pub --severity-threshold=high
```

#### Schritt 4: Automatische Fixes (wenn verfügbar)

```bash
# Versucht automatisch Updates für unsichere Dependencies zu finden
snyk test --file=pubspec.yaml --package-manager=dart
```

## Wichtige Befehle

### Dart/Flutter Pub Dependencies testen
```bash
snyk test --file=pubspec.yaml --package-manager=pkg:pub
```

### Nur High/Critical Severity prüfen
```bash
snyk test --file=pubspec.yaml --package-manager=pkg:pub --severity-threshold=high
```

### Ergebnisse im Snyk Dashboard speichern
```bash
snyk monitor --file=pubspec.yaml --package-manager=pkg:pub
```

### Continuous Monitoring einrichten
```bash
snyk monitor --file=pubspec.yaml --package-manager=pkg:pub
```

### Native Dependencies scannen (Android - Gradle)

**Wichtig:** App muss erst gebaut werden!

```bash
# Android App bauen
flutter build apk --debug

# Gradle Dependencies scannen
snyk test --file=android/app/build.gradle.kts --package-manager=gradle
```

### Native Dependencies scannen (iOS - CocoaPods)

**Wichtig:** App muss erst gebaut werden!

```bash
# iOS App bauen
flutter build ios --debug

# CocoaPods Dependencies scannen (wenn Podfile vorhanden)
cd ios && snyk test --file=Podfile --package-manager=cocoapods
```

## Snyk Policy anpassen

Die Datei `.snyk` enthält Regeln, um bestimmte Schwachstellen zu ignorieren oder zu patchen.

**WICHTIG:** Ignoriere nur Schwachstellen, wenn du:
- Die Risiken verstanden hast
- Keine Updates verfügbar sind
- Das Risiko für dein Projekt akzeptabel ist

Beispiel für Ignore-Regel:
```yaml
ignore:
  SNYK-JS-PACRESOLVER-1564857:
    - '*':
        reason: Keine Updates verfügbar, Risiko für dieses Projekt akzeptabel
        expires: '2025-12-31T23:59:59.000Z'
```

## Integration in CI/CD Pipeline

Wenn du eine eigene CI/CD Pipeline hast, füge diesen Schritt hinzu:

```yaml
- name: Snyk Security Scan
  run: |
    npm install -g snyk
    snyk test --file=pubspec.yaml --package-manager=dart || true
  env:
    SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
```

## Häufige Probleme

### "Unsupported package manager 'dart'"

**Lösung:** Verwende `pkg:pub` statt `dart`!
```bash
# ❌ FALSCH:
snyk test --file=pubspec.yaml --package-manager=dart

# ✅ RICHTIG:
snyk test --file=pubspec.yaml --package-manager=pkg:pub
```

### "Snyk konnte pubspec.yaml nicht erkennen"

Snyk unterstützt Dart/Flutter über `pkg:pub`. Stelle sicher, dass du eine aktuelle Version hast:
```bash
snyk --version
snyk update
```

### "No supported files detected"

Stelle sicher, dass `pubspec.yaml` und `pubspec.lock` im Root-Verzeichnis existieren:
```bash
# Für Pub Dependencies:
snyk test --file=pubspec.yaml --package-manager=pkg:pub

# Für native Dependencies (nach Build):
snyk test --file=android/app/build.gradle.kts --package-manager=gradle
```

## Tipps

1. **Regelmäßige Scans:** Die GitHub Action führt wöchentlich automatisch Scans durch
2. **Pull Request Checks:** Scans werden automatisch bei jedem PR ausgeführt
3. **Dashboard nutzen:** Snyk Dashboard bietet Übersicht über alle Projekte
4. **Fix-Pull-Requests:** Snyk kann automatisch PRs mit Fixes erstellen (Premium Feature)

## Weitere Ressourcen

- [Snyk Dokumentation](https://docs.snyk.io/)
- [Snyk für Dart/Flutter](https://docs.snyk.io/products/snyk-open-source/language-and-package-manager-support/snyk-for-dart)
- [Snyk GitHub Action](https://github.com/snyk/actions)

## Support

Bei Fragen zur Snyk-Integration:
- Snyk Support: https://support.snyk.io/
- Snyk Community: https://snyk.io/community/

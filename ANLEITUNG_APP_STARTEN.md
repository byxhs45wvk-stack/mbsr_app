# App anschauen - Anleitung

## Voraussetzungen
- Flutter muss installiert sein
- Ein Emulator/Simulator oder physisches Gerät muss verfügbar sein

## Option 1: Flutter im Terminal starten

### 1. Flutter-Pfad prüfen
Falls Flutter nicht im PATH ist, finde den Flutter-Pfad:
```bash
# Typischer Flutter-Installationspfad auf macOS:
# ~/flutter/bin/flutter
# oder
# /usr/local/flutter/bin/flutter
```

### 2. Verfügbare Geräte anzeigen
```bash
cd /Users/ch70bure/Privat/mbsr_app
flutter devices
```

### 3. App starten

#### Für iOS Simulator (macOS):
```bash
flutter run -d ios
```

#### Für Android Emulator:
```bash
flutter run -d android
```

#### Für macOS Desktop:
```bash
flutter run -d macos
```

#### Für Chrome/Web (schnell zum Testen):
```bash
flutter run -d chrome
```

## Option 2: In VS Code starten
1. Öffne das Projekt in VS Code
2. Drücke `F5` oder klicke auf "Run and Debug"
3. Wähle "Flutter" als Debug-Konfiguration
4. Wähle ein Gerät aus der Liste

## Option 3: In Android Studio starten
1. Öffne das Projekt in Android Studio
2. Klicke auf den "Run" Button (grüner Play-Button)
3. Wähle ein Gerät aus

## Option 4: Hot Reload während Entwicklung
Während die App läuft:
- Drücke `r` im Terminal für Hot Reload
- Drücke `R` für Hot Restart
- Drücke `q` zum Beenden

## Falls Flutter nicht installiert ist:

### Installation auf macOS:
1. Lade Flutter herunter: https://flutter.dev/docs/get-started/install/macos
2. Extrahiere das Archiv
3. Füge Flutter zum PATH hinzu:
```bash
export PATH="$PATH:`pwd`/flutter/bin"
```
4. Führe aus: `flutter doctor`

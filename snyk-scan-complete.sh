#!/bin/bash

# Kompletter Snyk Security Scan für Flutter-Projekt
# Scannt sowohl Pub Dependencies als auch native Dependencies (Android/iOS)

echo "🔍 Snyk Security Scan - Komplett wird gestartet..."
echo ""

# Prüfe ob Snyk installiert ist
if ! command -v snyk &> /dev/null; then
    echo "❌ Snyk ist nicht installiert!"
    echo ""
    echo "Installation:"
    echo "  npm install -g snyk"
    echo "  oder"
    echo "  brew install snyk (macOS)"
    echo ""
    exit 1
fi

# Prüfe ob authentifiziert
if ! snyk auth --check &> /dev/null; then
    echo "⚠️  Du bist nicht bei Snyk authentifiziert!"
    echo "Führe 'snyk auth' aus, um dich anzumelden."
    exit 1
fi

# Flutter Dependencies installieren
echo "📦 Flutter Dependencies werden installiert..."
flutter pub get

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1️⃣  SCAN: Dart/Flutter Pub Dependencies"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Test-Modus für Dart/Flutter Pub Dependencies
snyk test \
    --file=pubspec.yaml \
    --package-manager=pkg:pub \
    --severity-threshold=high \
    || echo "⚠️  Scan beendet mit Warnungen/Fehlern"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "2️⃣  SCAN: Android Gradle Dependencies (optional)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Prüfe ob Android Build vorhanden ist
if [ -f "android/app/build.gradle.kts" ]; then
    echo ""
    echo "ℹ️  Android Build-Datei gefunden."
    echo "   Optional: Scanne auch native Android Dependencies (benötigt Build, dauert länger)"
    echo "   Möchtest du Android Dependencies scannen? (j/n)"
    echo "   [Empfehlung: 'n' für schnellen Scan, 'j' für vollständigen Scan]"
    read -r answer
    
    if [ "$answer" = "j" ] || [ "$answer" = "J" ] || [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
        echo ""
        echo "🔨 Android App wird gebaut (Debug-Modus)..."
        echo "   ⏳ Das kann 1-5 Minuten dauern..."
        flutter build apk --debug || {
            echo "⚠️  Android Build fehlgeschlagen"
            echo "   Mögliche Ursachen: Android SDK nicht installiert oder konfiguriert"
            echo "   Überspringe Android-Scan und fahre fort..."
        }
        
        if [ -f "android/app/build.gradle.kts" ] && [ -d "build/app" ]; then
            echo ""
            echo "🔍 Scanne Android Gradle Dependencies..."
            snyk test \
                --file=android/app/build.gradle.kts \
                --package-manager=gradle \
                --severity-threshold=high \
                || echo "⚠️  Gradle-Scan beendet mit Warnungen/Fehlern"
        fi
    else
        echo ""
        echo "✅ Android-Scan übersprungen (nur Pub Dependencies wurden gescannt)"
        echo "   ℹ️  Das ist meist ausreichend für einen ersten Security-Check!"
    fi
else
    echo ""
    echo "⏭️  Keine Android Build-Datei gefunden, überspringe Android-Scan"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 SCAN ABGESCHLOSSEN!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "ℹ️  Für detaillierte Ergebnisse im Snyk Dashboard:"
echo "   snyk monitor --file=pubspec.yaml --package-manager=pkg:pub"
echo ""
echo "📝 Tipp: Für iOS-Scan baue die iOS App und führe aus:"
echo "   cd ios && snyk test --file=Podfile --package-manager=cocoapods"
echo ""

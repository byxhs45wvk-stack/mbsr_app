#!/bin/bash

# Snyk Security Scan Script für Flutter-Projekt
# Dieses Script führt einen Snyk Security Scan durch

echo "🔍 Snyk Security Scan wird gestartet..."
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
    echo "Dann authentifiziere dich mit:"
    echo "  snyk auth"
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

# Snyk Scan durchführen
echo ""
echo "🔒 Snyk Security Scan wird durchgeführt..."
echo ""

# Test-Modus für Dart/Flutter Pub Dependencies
echo "🔍 Scanne Dart/Flutter Pub Dependencies..."
snyk test \
    --file=pubspec.yaml \
    --package-manager=pkg:pub \
    --severity-threshold=high \
    || true

echo ""
echo "📊 Dart/Flutter Scan abgeschlossen!"
echo ""
echo "ℹ️  Hinweis: Für native Dependencies (Android/iOS) muss die App erst gebaut werden."
echo "   Dann kannst du Gradle (Android) oder CocoaPods (iOS) scannen."
echo ""
echo "Für detaillierte Ergebnisse im Snyk Dashboard:"
echo "  snyk monitor --file=pubspec.yaml --package-manager=pkg:pub"
echo ""

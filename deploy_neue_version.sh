#!/bin/bash

# Script für ein sauberes Deployment der MBSR App
echo "🚀 Neue Version deployen..."

# 1. Cache löschen
echo ""
echo "1️⃣  Lösche Flutter Build Cache..."
flutter clean
echo "✅ Flutter Cache gelöscht"

# 2. Dependencies laden
echo ""
echo "2️⃣  Installiere Dependencies neu..."
flutter pub get
echo "✅ Dependencies installiert"

# 3. Web-Build erstellen (mit dem flüssigen CanvasKit Renderer)
echo ""
echo "3️⃣  Erstelle neuen Web-Build..."
# WICHTIG: Die Option heißt --web-renderer (mit er) oder kurz -r
# Wir nutzen hier die explizite Zuweisung für maximale Stabilität
flutter build web --release --web-renderer canvaskit
echo "✅ Neuer Build erstellt"

# 4. Check, ob Build erfolgreich war
if [ -d "build/web" ]; then
    echo ""
    echo "4️⃣  Prüfe Build-Größe..."
    du -sh build/web
    
    # 5. Firebase Deploy
    echo ""
    echo "5️⃣  Deploy auf Firebase Hosting..."
    firebase deploy --only hosting
    echo ""
    echo "✅ Fertig! Die neue Version ist jetzt live."
else
    echo ""
    echo "❌ FEHLER: Der Build-Ordner wurde nicht erstellt. Abbruch."
    exit 1
fi
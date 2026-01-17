#!/bin/bash

echo "🔧 Firebase CLI Problem beheben..."
echo ""

# Schritt 1: Cache löschen
echo "1️⃣  Lösche Firebase Cache..."
rm -rf ~/.cache/firebase/tools
rm -rf ~/.cache/firebase
echo "✅ Cache gelöscht"
echo ""

# Schritt 2: Alte Firebase Tools deinstallieren
echo "2️⃣  Deinstalliere alte Firebase Tools..."
npm uninstall -g firebase-tools 2>/dev/null || true
echo "✅ Alte Version entfernt"
echo ""

# Schritt 3: Node.js Version prüfen
echo "3️⃣  Prüfe Node.js Version..."
node --version
npm --version
echo ""

# Schritt 4: Firebase Tools neu installieren (neueste Version)
echo "4️⃣  Installiere Firebase Tools (neueste Version)..."
npm install -g firebase-tools@latest
echo "✅ Firebase Tools installiert"
echo ""

# Schritt 5: Firebase Version prüfen
echo "5️⃣  Prüfe Firebase CLI Version..."
firebase --version
echo ""

echo "✅ Fertig! Versuche jetzt:"
echo "   firebase login"
echo "   firebase deploy --only hosting"

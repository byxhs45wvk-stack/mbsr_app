# Snyk Scan jetzt ausführen - Anleitung

## ⚡ Schnellstart - FUNKTIONIERT SOFORT, KEIN BUILD NÖTIG!

### ✅ Option 1: Einfacher Scan (empfohlen - KEIN BUILD nötig!)

**Wichtig:** Dieser Scan funktioniert **sofort**, ohne dass die App gebaut werden muss!
- ✅ `pubspec.yaml` ist vorhanden
- ✅ `pubspec.lock` ist vorhanden  
- ✅ **Kein Build nötig!**

```bash
# 1. Snyk authentifizieren (falls noch nicht geschehen)
snyk auth

# 2. Scan ausführen (funktioniert sofort!)
./snyk-scan.sh

# Oder manuell:
snyk test --file=pubspec.yaml --package-manager=pkg:pub
```

### Option 2: Kompletter Scan (optional - mit Android/iOS Build)

**Hinweis:** Dieser Scan fragt, ob auch native Dependencies gescannt werden sollen.
- **"n"** = Nur Pub Dependencies (wie Option 1, kein Build)
- **"j"** = Auch native Dependencies (benötigt Android-Build, 1-5 Minuten)

```bash
# 1. Snyk authentifizieren (falls noch nicht geschehen)
snyk auth

# 2. Kompletter Scan
./snyk-scan-complete.sh

# Antwort bei Nachfrage: 
#   "n" = Schneller Scan ohne Build (empfohlen!)
#   "j" = Vollständiger Scan mit Build (optional)
```

## 📋 Schritt-für-Schritt

### Schritt 1: Prüfe ob Snyk installiert ist

```bash
snyk --version
```

Wenn nicht installiert:
```bash
npm install -g snyk
# oder
brew install snyk
```

### Schritt 2: Authentifiziere dich

```bash
snyk auth
```

Dies öffnet deinen Browser zur Anmeldung bei snyk.io

### Schritt 3: Scan ausführen

**Einfacher Scan (empfohlen):**
```bash
./snyk-scan.sh
```

**Kompletter Scan:**
```bash
./snyk-scan-complete.sh
```

## 📊 Was passiert beim Scan?

1. ✅ Flutter Dependencies werden installiert (`flutter pub get`)
2. ✅ Snyk analysiert `pubspec.yaml` und `pubspec.lock`
3. ✅ Prüft alle Dependencies auf bekannte Sicherheitslücken
4. ✅ Zeigt Ergebnisse im Terminal

## 📝 Beispiel-Output

### Wenn keine Probleme gefunden werden:
```
Testing /Users/ch70bure/Privat/mbsr_app...

✓ No known vulnerabilities found

Tested 45 dependencies for known issues, found 0 issues
```

### Wenn Probleme gefunden werden:
```
Testing /Users/ch70bure/Privat/mbsr_app...

✗ Medium severity vulnerability found in firebase_core@4.3.0
  Description: Prototype pollution vulnerability
  Info: https://snyk.io/vuln/SNYK-DART-FIREBASECORE-1234567
  Fix: Upgrade firebase_core to ^4.3.1
```

## 🔍 Nach dem Scan

### Ergebnisse im Snyk Dashboard speichern

```bash
snyk monitor --file=pubspec.yaml --package-manager=pkg:pub
```

Dies erstellt einen Bericht im Snyk Dashboard (app.snyk.io)

### Detaillierten Bericht erstellen

```bash
snyk test --file=pubspec.yaml --package-manager=pkg:pub --json > snyk-report.json
```

## ❓ Häufige Fragen

### "Snyk ist nicht installiert"
```bash
npm install -g snyk
# oder
brew install snyk
```

### "Du bist nicht authentifiziert"
```bash
snyk auth
```

### "Unsupported package manager"
Stelle sicher, dass du `pkg:pub` (nicht `dart`) verwendest:
```bash
# ❌ FALSCH:
snyk test --file=pubspec.yaml --package-manager=dart

# ✅ RICHTIG:
snyk test --file=pubspec.yaml --package-manager=pkg:pub
```

## ✅ Checkliste

- [ ] Snyk installiert (`snyk --version`)
- [ ] Bei Snyk authentifiziert (`snyk auth`)
- [ ] Scan ausgeführt (`./snyk-scan.sh`)
- [ ] Ergebnisse geprüft
- [ ] Bei Bedarf Updates durchgeführt (`flutter pub upgrade`)

## 🎯 Zusammenfassung

**Aktuell:** Noch kein Scan durchgeführt

**Nächster Schritt:** Führe `./snyk-scan.sh` aus!

```bash
snyk auth          # Einmalig: Anmeldung
./snyk-scan.sh     # Scan starten
```

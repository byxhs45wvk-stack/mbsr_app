# 🚀 Appwrite Cloud Setup für MBSR App

## Projekt-Informationen
- **Projekt-ID:** `696befd00018180d10ff`
- **Endpoint:** `https://fra.cloud.appwrite.io/v1`
- **Region:** Frankfurt (EU)

---

## 1️⃣ DATABASE ERSTELLEN

### Schritt 1: Neue Database anlegen
1. Gehe zu [Appwrite Console](https://cloud.appwrite.io)
2. Wähle dein Projekt (`696befd00018180d10ff`)
3. Klicke links auf **"Databases"**
4. Klicke **"Create database"**
5. **Database ID:** `mbsr_database` (genau so eingeben!)
6. **Name:** `MBSR Database`
7. Klicke **"Create"**

---

## 2️⃣ COLLECTIONS ERSTELLEN

### Collection 1: Users (Benutzer-Profile)

1. In der Database `mbsr_database`, klicke **"Create collection"**
2. **Collection ID:** `users` (genau so!)
3. **Name:** `Users`
4. Klicke **"Create"**

#### Attributes (Felder) hinzufügen:

Klicke **"Create attribute"** und füge **NUR** diese drei Felder hinzu:

| Attribute Key | Type | Size | Required |
|---|---|---|---|
| `email` | String | 255 | ✅ Yes |
| `role` | String | 50 | ✅ Yes |
| `name` | String | 255 | ❌ No |

**Wichtig:** Keine Passwörter oder kryptische IDs hier speichern! Das macht Appwrite Auth automatisch.

#### Permissions setzen:

Klicke auf **"Settings"** (oben rechts) → **"Permissions"**

**Wichtig:** Lösche ALLE Standard-Permissions und füge hinzu:

| Role | Permissions |
|---|---|
| `Any` | ❌ (nichts) |
| `Users` | ✅ Read (nur eigenes Dokument) |

**Custom Permission Rule:**
```
Read: document.email == $user.email
```

#### Indexes erstellen:

Klicke **"Indexes"** → **"Create index"**

| Key | Type | Order |
|---|---|---|
| `email` | Key | ASC |

**Wichtig:** Dieser Index ermöglicht schnelle Suche nach Email!

---

### Collection 2: Kurs-Daten (optional, falls du Daten in Appwrite speichern willst)

**Hinweis:** Aktuell sind deine Kursdaten in `app_daten.dart` (lokal). 
Falls du sie später in die Cloud migrieren willst:

1. **Collection ID:** `kurs_daten`
2. **Name:** `Kurs Daten`
3. **Attributes:** (nach Bedarf)
4. **Permissions:** Nur Users mit `role == 'mbsr'`

---

## 3️⃣ STORAGE BUCKET ERSTELLEN (Shared Bucket)

Da im Free Plan nur ein Bucket möglich ist, nutzen wir einen gemeinsamen Bucket für alle Medien.

1. Klicke links auf **"Storage"**
2. Klicke **"Create bucket"**
3. **Bucket ID:** `mbsr_content` (genau so!)
4. **Name:** `MBSR Content`
5. **Permissions:**
   - ✅ Read: `Any` (oder `Users` für mehr Sicherheit)
   - ❌ Create/Update/Delete: (nur Admin)
6. **File Security:** Enabled (Wichtig für Privatsphäre!)
7. **Maximum File Size:** 100 MB (reicht für Audio)
8. **Allowed File Extensions:** `mp3, wav, m4a, pdf`
9. Klicke **"Create"**

---

## 4️⃣ USERS ERSTELLEN (Deine MBSR-Teilnehmer)

### Schritt 1: User in Authentication erstellen

1. Klicke links auf **"Auth"**
2. Klicke **"Create user"**
3. **Email:** `test@mbsr.de` (Beispiel)
4. **Password:** `[Sicheres Passwort]`
5. **Name:** `Test User` (optional)
6. Klicke **"Create"**

### Schritt 2: User-Dokument in Database erstellen

1. Gehe zu **Databases** → `mbsr_database` → Collection `users`
2. Klicke **"Create document"**
3. **Document ID:** Automatisch generieren lassen
4. **Felder ausfüllen:**
   - `email`: `test@mbsr.de` (gleiche Email wie in Auth!)
   - `role`: `mbsr`
   - `name`: `Test User` (optional)
5. Klicke **"Create"**

**WICHTIG:** Für jeden User brauchst du:
- ✅ Einen Auth-Account (in "Auth")
- ✅ Ein User-Dokument (in "Databases" → "users")

---

## 5️⃣ AUDIO/PDF-DATEIEN HOCHLADEN

### Audios hochladen:

1. Gehe zu **Storage** → Bucket `audios`
2. Klicke **"Create file"**
3. Wähle deine MP3-Datei
4. **File ID:** Automatisch oder custom (z.B. `sitzmeditation_woche1`)
5. Klicke **"Create"**
6. **Kopiere die File-URL** (brauchst du für `app_daten.dart`)

### PDFs hochladen:

Gleicher Prozess im Bucket `pdfs`

---

## 6️⃣ FILE-URLS IN APP EINTRAGEN

Nach dem Upload erhältst du URLs wie:
```
https://fra.cloud.appwrite.io/v1/storage/buckets/audios/files/[FILE_ID]/view?project=696befd00018180d10ff
```

Diese URLs trägst du in `lib/app_daten.dart` ein:

```dart
'url': 'https://fra.cloud.appwrite.io/v1/storage/buckets/audios/files/sitzmeditation_woche1/view?project=696befd00018180d10ff',
```

---

## 7️⃣ TESTEN

### Nach dem Setup:

```bash
# 1. Dependencies installieren
flutter pub get

# 2. App starten
flutter run -d chrome

# 3. Teste:
# - Login mit test@mbsr.de
# - Navigation funktioniert
# - Audios werden geladen (URLs müssen korrekt sein!)
```

---

## 🔒 SECURITY CHECKLIST

Nach dem Setup, prüfe:

- ✅ Users Collection: Nur eigenes Dokument lesbar
- ✅ Storage Buckets: Nur lesen erlaubt, kein Upload
- ✅ Auth: Nur du kannst User erstellen (in Console)
- ✅ Keine öffentlichen Write-Permissions

---

## ⚠️ WICHTIGE HINWEISE

### User-Verwaltung:

**Für jeden neuen MBSR-Teilnehmer:**
1. Erstelle Auth-Account (in "Auth")
2. Erstelle User-Dokument (in "Databases" → "users")
3. **Email muss in beiden identisch sein!**
4. Setze `role: 'mbsr'` im Dokument

### Datenmigration von Firebase:

Falls du bestehende User hast:
- Exportiere User-Liste aus Firebase Auth
- Erstelle sie manuell in Appwrite (oder nutze Appwrite API für Bulk-Import)

### Audio/PDF-Migration:

- Lade alle Dateien aus Firebase Storage herunter
- Lade sie in Appwrite Storage hoch
- Aktualisiere URLs in `app_daten.dart`

---

## 📞 SUPPORT

Bei Problemen:
- Appwrite Docs: https://appwrite.io/docs
- Discord: https://appwrite.io/discord
- GitHub: https://github.com/appwrite/appwrite

---

**Geschätzte Setup-Zeit:** 30-45 Minuten

**Danach ist die Migration komplett!** 🎉

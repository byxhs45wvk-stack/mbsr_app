# App auf dem Handy öffnen - Anleitung

## Option 1: Lokal im Netzwerk (schnell & einfach)

### Schritt 1: Deine lokale IP-Adresse finden

```bash
# macOS:
ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1
```

Oder manuell:
- Systemeinstellungen → Netzwerk → WLAN → Details → IPv4-Adresse
- Beispiel: `192.168.1.100`

### Schritt 2: App im Netzwerk-Modus starten

```bash
cd /Users/ch70bure/Privat/mbsr_app
flutter run -d chrome --web-hostname 0.0.0.0 --web-port 8080
```

### Schritt 3: Auf dem Handy öffnen

**Wichtig:** Handy und Computer müssen im **selben WLAN** sein!

Öffne im Browser deines Handys:
```
http://<deine-ip-adresse>:8080
```

Beispiel:
- `http://192.168.1.100:8080`

---

## Option 2: Deployment (Öffentliche URL)

Da Firebase entfernt wurde, muss für eine öffentliche URL ein neuer Hosting-Anbieter (z.B. Vercel, Netlify oder GitHub Pages) genutzt werden. 

Bis ein neuer Hosting-Anbieter konfiguriert ist, ist die App am einfachsten über **Option 1 (WLAN)** erreichbar.

---

## Tipps für Handy-Nutzung:

1. **Zum Home-Bildschirm hinzufügen:**
   - iOS Safari: Teilen → Zum Home-Bildschirm
   - Android Chrome: Menü → Zum Startbildschirm hinzufügen

2. **Fullscreen-Modus:**
   - Die App öffnet sich dann wie eine native App

3. **Performance:**
   - Für beste Performance sollte die App über einen Webserver (Hosting) laufen, nicht nur lokal.

import 'package:flutter/material.dart';

/// Zentrale Verwaltung für Impressum und Datenschutz-Dialoge
/// Verhindert Code-Duplikation über mehrere Dateien hinweg
class LegalDialogs {
  // Texte zentral definiert (Single Source of Truth)
  static const String impressumText = 'Dr. Christian Hahn\n'
      'Salomonstr. 2\n'
      '04103 Leipzig\n\n'
      'E-Mail: achtsamkeit@belight-leipzig.de';

  static const String datenschutzText =
      'Diese App wird über Firebase gehostet. Es werden keine '
      'persönlichen Daten gespeichert. Die Verarbeitung beschränkt '
      'sich auf technisch notwendige Protokolldaten beim App-Aufruf.';

  /// Zeigt Impressum-Dialog
  static Future<void> showImpressum(BuildContext context) {
    return _showDialog(context, 'Impressum', impressumText);
  }

  /// Zeigt Datenschutz-Dialog
  static Future<void> showDatenschutz(BuildContext context) {
    return _showDialog(context, 'Datenschutz', datenschutzText);
  }

  /// Generischer Dialog für Rechtsinformationen
  static Future<void> _showDialog(
    BuildContext context,
    String title,
    String content,
  ) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF8B7565),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(color: Color(0xFF8B7565), height: 1.5),
          ),
        ),
        backgroundColor: const Color(0xFFFAF8F5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Schließen',
              style: TextStyle(color: Color(0xFFA68B6F)),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:ui';

class AppStyles {
  // Global Colors (Headspace Style - 2026 Modern & Vibrant)
  static const Color bgColor = Color(0xFFFFFFFF); // Klares Weiß (modern)
  static const Color primaryOrange = Color(0xFFFF6B6B); // Warmes Korallenrot (weniger grell, aber kräftig)
  static const Color accentOrange = Color(0xFFFF8C69); // Warmes Lachs-Orange
  static const Color accentPink = Color(0xFFFF6B9D); // Kräftiges Pink (für Highlights)
  static const Color accentCoral = Color(0xFFFF8FA3); // Sanftes Korallen-Pink
  static const Color successGreen = Color(0xFF4ECDC4); // Frisches Türkis (Abgeschlossen/Erfolg)
  static const Color accentCyan = Color(0xFF5BC0BE); // Lebendiges Cyan
  static const Color textDark = Color(0xFF2C3E50); // Modernes Dunkelgrau (Texte)
  static const Color softBrown = textDark; // Alias für Rückwärtskompatibilität
  static const Color sageGreen = successGreen; // Alias für Rückwärtskompatibilität
  static const Color borderColor = Color(0xFFE0E0E0); // Sehr feine graue Umrandung

  // Border Radius
  static const double borderRadius = 28.0;
  static final RoundedRectangleBorder cardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1.5),
  );

  // Typography (Nunito)
  static TextStyle get titleStyle => const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textDark,
    height: 1.3,
  );

  static TextStyle get headingStyle => const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: textDark,
    height: 1.2,
  );

  static TextStyle get subTitleStyle => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textDark,
  );

  static TextStyle get bodyStyle =>
      const TextStyle(fontSize: 14, color: textDark, height: 1.5);

  // Glassmorphismus (Frosted Glass Effect) - 2026 Design
  static ImageFilter get glassBlur => ImageFilter.blur(sigmaX: 15, sigmaY: 15);
  static Color get glassBackground => Colors.white.withOpacity(0.6);
  static Color get glassBorder => Colors.white.withOpacity(0.2);
}

import 'package:flutter/material.dart';

class AppStyles {
  // Global Colors (Headspace Style)
  static const Color bgColor = Color(0xFFFBF7F2); // Sanftes Off-White/Beige
  static const Color primaryOrange = Color(0xFFC97D60); // Warmes Orange (Aktiv)
  static const Color accentOrange = Color(0xFFE89B7A); // Hellere Nuance
  static const Color sageGreen = Color(
    0xFF7A8B6F,
  ); // Ruhiges Salbeigrün (Abgeschlossen)
  static const Color softBrown = Color(0xFF8B7565); // Sanftes Braun (Texte)
  static const Color borderColor = Color(
    0xFFE0E0E0,
  ); // Sehr feine graue Umrandung

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
    color: softBrown,
    height: 1.3,
  );

  static TextStyle get headingStyle => const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: softBrown,
    height: 1.2,
  );

  static TextStyle get subTitleStyle => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: softBrown,
  );

  static TextStyle get bodyStyle =>
      const TextStyle(fontSize: 14, color: softBrown, height: 1.5);
}

import 'package:flutter/material.dart';

/// Sanfte, harmonische Farbpalette im Headspace-Stil
/// Erdige Töne, aber sanfter und moderner
class AppColors {
  // Hauptfarben - Sanftere erdige Töne
  static const Color primaryBrown = Color(0xFFA68B6F); // Sanfterer Braunton (Hauptfarbe)
  static const Color textBrown = Color(0xFF8B7565); // Sanfterer Braun für Text
  static const Color accentOlive = Color(0xFF7A8B6F); // Sanfteres Olivgrün
  static const Color accentTerracotta = Color(0xFFC97D60); // Sanfteres Terrakotta
  
  // Hintergründe - Heller, mehr Weiß
  static const Color backgroundLight = Color(0xFFFAF8F5); // Sehr helles Beige
  static const Color backgroundBeige = Color(0xFFF5EFE8); // Sanftes Beige für AppBars
  static const Color backgroundWarm = Color(0xFFFAF8F5); // Warmes, sehr helles Beige
  
  // Akzente & Borders
  static const Color borderLight = Color(0xFFE8DCC8); // Sanftere Sandfarbe für Borders
  static const Color borderSubtle = Color(0xFFE8DCC8); // Sehr subtile Borders
  
  // Text & Grautöne
  static const Color textPrimary = Color(0xFF8B7565);
  static const Color textSecondary = Color(0xFF8B7565);
  static const Color textLight = Color(0xFF8B7565);
  
  // Für Status-Indikatoren
  static Color get activeColor => accentOlive;
  static Color get inactiveColor => borderLight;
  
  // Helper-Methoden für Opacity-Varianten
  static Color primaryBrownWithOpacity(double opacity) => primaryBrown.withOpacity(opacity);
  static Color accentOliveWithOpacity(double opacity) => accentOlive.withOpacity(opacity);
  static Color accentTerracottaWithOpacity(double opacity) => accentTerracotta.withOpacity(opacity);
}

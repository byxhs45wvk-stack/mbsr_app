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

  // Semantische Farben (Info, Warning, Error)
  static const Color infoBlue = Color(0xFF6B9BD2); // Sanftes Blau
  static const Color warningYellow = Color(0xFFFFC107); // Warmes Gelb
  static const Color errorRed = Color(0xFFE57373); // Sanftes Rot

  // Border Radius
  static const double borderRadius = 28.0;
  static final RoundedRectangleBorder cardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1.5),
  );

  // ============================================
  // TYPOGRAPHY (Nunito) - Optimiert
  // ============================================
  
  // Font Weights (konsistent)
  static const FontWeight fontWeightBold = FontWeight.w700;      // Hauptüberschriften
  static const FontWeight fontWeightSemiBold = FontWeight.w600;  // Unterüberschriften, wichtige Labels
  static const FontWeight fontWeightRegular = FontWeight.w400;    // Body-Text, Standard
  static const FontWeight fontWeightLight = FontWeight.w300;     // Dekorative Texte, Zitate

  // Title Style (große Überschriften)
  static TextStyle get titleStyle => const TextStyle(
    fontSize: 28,
    fontWeight: fontWeightBold,      // 700
    color: textDark,
    height: 1.2,                    // Kompakt, kraftvoll (optimiert von 1.3)
    letterSpacing: -0.5,            // Kompakter, moderner
  );

  // Heading Style (Unterüberschriften)
  static TextStyle get headingStyle => const TextStyle(
    fontSize: 22,
    fontWeight: fontWeightBold,      // 700
    color: textDark,
    height: 1.2,                    // Kompakt, kraftvoll
    letterSpacing: -0.3,            // Leicht kompakter
  );

  // SubTitle Style (Zwischenüberschriften)
  static TextStyle get subTitleStyle => const TextStyle(
    fontSize: 16,
    fontWeight: fontWeightSemiBold, // 600
    color: textDark,
    height: 1.4,                    // Ausgewogen
    letterSpacing: 0.0,             // Neutral
  );

  // Body Style (Haupttext)
  static TextStyle get bodyStyle => const TextStyle(
    fontSize: 14,
    fontWeight: fontWeightRegular,   // 400
    color: textDark,
    height: 1.6,                    // Luftig, entspannt lesbar (optimiert von 1.5)
    letterSpacing: 0.5,             // Mehr Luft, besser lesbar
  );

  // Small Text Style (kleine Labels, Captions)
  static TextStyle get smallTextStyle => const TextStyle(
    fontSize: 12,
    fontWeight: fontWeightRegular,   // 400
    color: textDark,
    height: 1.4,                    // Ausgewogen
    letterSpacing: 0.3,             // Leicht mehr Luft
  );

  // Decorative Text Style (Zitate, dekorative Texte)
  static TextStyle get decorativeTextStyle => const TextStyle(
    fontSize: 14,
    fontWeight: fontWeightLight,      // 300
    color: textDark,
    height: 1.5,
    letterSpacing: 0.8,             // Mehr Luft für elegantes Aussehen
    fontStyle: FontStyle.italic,     // Optional für Zitate
  );

  // Glassmorphismus (Frosted Glass Effect) - 2026 Design
  static ImageFilter get glassBlur => ImageFilter.blur(sigmaX: 15, sigmaY: 15);
  static Color get glassBackground => Colors.white.withOpacity(0.6);
  static Color get glassBorder => Colors.white.withOpacity(0.2);

  // ============================================
  // SPACING SYSTEM (Design Token System)
  // ============================================
  
  // Base Spacing Values
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Predefined EdgeInsets for Consistency
  // Cards
  static EdgeInsets get cardPadding => const EdgeInsets.all(spacingL);
  static EdgeInsets get cardPaddingLarge => const EdgeInsets.all(spacingXL);
  static EdgeInsets get cardPaddingSmall => const EdgeInsets.all(spacingM);

  // Buttons
  static EdgeInsets get buttonPadding => const EdgeInsets.symmetric(
    horizontal: spacingL,
    vertical: spacingM,
  );
  static EdgeInsets get buttonPaddingSmall => const EdgeInsets.symmetric(
    horizontal: spacingM,
    vertical: spacingS,
  );

  // Input Fields
  static EdgeInsets get inputPadding => const EdgeInsets.symmetric(
    horizontal: 20.0, // Slightly less than spacingL for better visual balance
    vertical: spacingM,
  );

  // Sections
  static EdgeInsets get sectionPadding => const EdgeInsets.all(spacingL);
  static EdgeInsets get sectionPaddingLarge => const EdgeInsets.all(spacingXL);

  // List Padding
  static EdgeInsets get listPadding => const EdgeInsets.all(spacingL);
  static EdgeInsets get listPaddingHorizontal => const EdgeInsets.symmetric(
    horizontal: spacingL,
  );

  // Screen Padding
  static EdgeInsets get screenPadding => const EdgeInsets.all(spacingL);
  static EdgeInsets get screenPaddingHorizontal => const EdgeInsets.symmetric(
    horizontal: spacingL,
  );

  // Whitespace Strategy: Spacing between elements
  // Zwischen Sektionen: spacingXL (32px)
  // Zwischen Cards: spacingM (16px)
  // Innerhalb Cards: spacingL (24px)
  // Kleine Abstände: spacingS (8px)

  // Predefined SizedBox for common spacing
  static Widget get spacingXSBox => const SizedBox(height: spacingXS);
  static Widget get spacingSBox => const SizedBox(height: spacingS);
  static Widget get spacingMBox => const SizedBox(height: spacingM);
  static Widget get spacingLBox => const SizedBox(height: spacingL);
  static Widget get spacingXLBox => const SizedBox(height: spacingXL);
  static Widget get spacingXXLBox => const SizedBox(height: spacingXXL);

  // Horizontal spacing
  static Widget get spacingXSHorizontal => const SizedBox(width: spacingXS);
  static Widget get spacingSHorizontal => const SizedBox(width: spacingS);
  static Widget get spacingMHorizontal => const SizedBox(width: spacingM);
  static Widget get spacingLHorizontal => const SizedBox(width: spacingL);

  // ============================================
  // DETAIL-OPTIMIERUNGEN (Design Tokens)
  // ============================================

  // 1. ICON-KONSISTENZ
  // Standardisierte Icon-Größen
  static const double iconSizeXS = 16.0;  // Sehr klein (z.B. in Badges)
  static const double iconSizeS = 20.0;   // Klein (z.B. in Cards)
  static const double iconSizeM = 24.0;   // Standard (Standard-Icons)
  static const double iconSizeL = 32.0;   // Groß (Prominente Icons)
  static const double iconSizeXL = 48.0;  // Sehr groß (Hero Icons)

  // Icon-Farben (konsistent)
  static Color iconColorActive = primaryOrange;
  static Color iconColorInactive = textDark.withOpacity(0.4);
  static Color iconColorSuccess = successGreen;
  static Color iconColorOnWhite = textDark.withOpacity(0.6);

  // 2. BADGE-DESIGN
  // Badge-Styles für kleine Status-Anzeigen
  static BoxDecoration badgeDecoration({required Color color}) => BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(12.0), // 12px Radius
  );

  static TextStyle get badgeTextStyle => const TextStyle(
    color: Colors.white,
    fontSize: 11.0, // 11-12px
    fontWeight: FontWeight.w600, // SemiBold
    height: 1.2,
  );

  // Badge-Höhe: 20px
  static const double badgeHeight = 20.0;
  static EdgeInsets get badgePadding => const EdgeInsets.symmetric(
    horizontal: spacingS,
    vertical: spacingXS,
  );

  // 3. DIVIDER-LINIEN
  // Sehr subtile Divider (0.5px, 10% Opacity)
  static Widget buildSubtleDivider({double? height}) {
    return Container(
      height: height ?? 0.5,
      margin: EdgeInsets.symmetric(vertical: spacingM),
      color: textDark.withOpacity(0.1),
    );
  }

  // Alternative: Whitespace statt Linien (moderner)
  static Widget buildSpacingDivider() {
    return SizedBox(height: spacingL);
  }

  // 4. TOOLTIPS
  // Tooltip-Styling (abgerundet, sanfter Shadow)
  static BoxDecoration get tooltipDecoration {
    return BoxDecoration(
      color: textDark.withOpacity(0.9),
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static TextStyle get tooltipTextStyle {
    return const TextStyle(
      color: Colors.white,
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
    );
  }

  static EdgeInsets get tooltipPadding => const EdgeInsets.symmetric(
    horizontal: spacingM,
    vertical: spacingS,
  );
}

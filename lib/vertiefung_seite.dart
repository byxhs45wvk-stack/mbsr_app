import 'package:flutter/material.dart';
import 'literatur_seite.dart';
import 'core/app_styles.dart';
import 'widgets/decorative_blobs.dart';

class VertiefungSeite extends StatelessWidget {
  final Map<String, dynamic> tagDerAchtsamkeit;
  final List<Map<String, String>> zusatzUebungen;

  const VertiefungSeite({
    super.key,
    required this.tagDerAchtsamkeit,
    required this.zusatzUebungen,
  });

  @override
  Widget build(BuildContext context) {
    return DecorativeBlobs(
      child: ListView(
        padding: AppStyles.listPadding,
        children: [
        // Header
        Text(
          "Vertiefung",
          style: AppStyles.headingStyle,
        ),
        AppStyles.spacingSBox,
        Text(
          "Zusätzliche Übungen und Ressourcen für deine Praxis",
          style: AppStyles.bodyStyle.copyWith(color: AppStyles.softBrown.withOpacity(0.7)),
        ),
        AppStyles.spacingXLBox,

        _buildSectionHeader("ZUSÄTZLICHE ÜBUNGEN"),
        AppStyles.spacingMBox,

        // Coming soon Card
        Card(
          elevation: 0,
          color: Colors.white,
          shape: AppStyles.cardShape,
          child: Padding(
            padding: AppStyles.cardPaddingLarge,
            child: Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppStyles.softBrown.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.schedule,
                      size: 40,
                      color: AppStyles.softBrown.withOpacity(0.3),
                    ),
                  ),
                  SizedBox(height: AppStyles.spacingL - AppStyles.spacingS), // 20px
                  Text(
                    "Coming soon",
                    style: AppStyles.subTitleStyle.copyWith(color: AppStyles.softBrown.withOpacity(0.5)),
                  ),
                  AppStyles.spacingSBox,
                  Text(
                    "Neue Übungen werden in Kürze hinzugefügt",
                    textAlign: TextAlign.center,
                    style: AppStyles.bodyStyle.copyWith(fontSize: 13, color: AppStyles.softBrown.withOpacity(0.4)),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: AppStyles.spacingXL + AppStyles.spacingS), // 40px

        _buildSectionHeader("LITERATUR & FORSCHUNG"),
        AppStyles.spacingMBox,
        
        Card(
          elevation: 0,
          color: Colors.white,
          shape: AppStyles.cardShape,
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LiteraturSeite()),
            ),
            borderRadius: BorderRadius.circular(28),
            child: Padding(
              padding: AppStyles.cardPadding,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppStyles.primaryOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.menu_book_outlined,
                      color: AppStyles.primaryOrange,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: AppStyles.spacingL - AppStyles.spacingS), // 20px
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Literatur & Forschung",
                          style: AppStyles.subTitleStyle,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Bücher, Artikel und Studien zu MBSR",
                          style: AppStyles.bodyStyle.copyWith(fontSize: 13, color: AppStyles.softBrown.withOpacity(0.6)),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppStyles.borderColor,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 100), // Platz für Floating Nav
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        title,
        style: AppStyles.bodyStyle.copyWith(
          letterSpacing: 1.5,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: AppStyles.softBrown.withOpacity(0.5),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'core/app_config.dart';
import 'core/app_styles.dart';

class TagDerAchtsamkeitSeite extends StatelessWidget {
  final Map<String, dynamic> daten;

  const TagDerAchtsamkeitSeite({super.key, required this.daten});

  Future<void> _oeffneEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'achtsamkeit@belight-leipzig.de',
    );
    if (!await launchUrl(emailUri)) {
      throw 'Konnte E-Mail-App nicht öffnen';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      appBar: AppBar(
        title: Text(
          'Tag der Achtsamkeit',
          style: AppStyles.headingStyle.copyWith(fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppStyles.softBrown, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Header-Bereich
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppStyles.primaryOrange,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppStyles.primaryOrange.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.spa, color: Colors.white, size: 48),
                const SizedBox(height: 24),
                const Text(
                  'Tag der Achtsamkeit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Ein spezieller Tag für Kursteilnehmer und Ehemalige.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 48),

          _buildSectionHeader("UNTERLAGEN"),
          const SizedBox(height: 16),

          if (daten['pdfs'] != null)
            ...List<Map<String, dynamic>>.from(daten['pdfs']).map(
              (pdf) => _buildPDFCard(pdf),
            ),

          const SizedBox(height: 40),

          _buildSectionHeader("NÄCHSTER TERMIN"),
          const SizedBox(height: 16),

          Card(
            elevation: 0,
            color: Colors.white,
            shape: AppStyles.cardShape,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, color: AppStyles.sageGreen, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        'Datum folgt',
                        style: AppStyles.subTitleStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Die Termine werden rechtzeitig per E-Mail bekannt gegeben.',
                    style: AppStyles.bodyStyle,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),

          _buildSectionHeader("KONTAKT"),
          const SizedBox(height: 16),

          Card(
            elevation: 0,
            color: Colors.white,
            shape: AppStyles.cardShape,
            child: InkWell(
              onTap: _oeffneEmail,
              borderRadius: BorderRadius.circular(28),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppStyles.sageGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.email_outlined, color: AppStyles.sageGreen),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Fragen?', style: AppStyles.bodyStyle.copyWith(fontSize: 13, color: AppStyles.softBrown.withOpacity(0.6))),
                          const SizedBox(height: 4),
                          Text(
                            'achtsamkeit@belight-leipzig.de',
                            style: AppStyles.subTitleStyle.copyWith(color: AppStyles.sageGreen),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: AppStyles.borderColor),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Hinweis
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppStyles.primaryOrange.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppStyles.primaryOrange.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppStyles.primaryOrange, size: 20),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Dieser Bereich steht auch nach Kursende für deine private Praxis zur Verfügung.",
                    style: AppStyles.bodyStyle.copyWith(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
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

  Widget _buildPDFCard(Map<String, dynamic> pdf) {
    final title = pdf['title'] ?? 'Unterlage';
    final appwriteId = pdf['appwrite_id'];
    final url = '${AppConfig.appwriteEndpoint}/storage/buckets/${AppConfig.pdfsBucketId}/files/$appwriteId/view?project=${AppConfig.appwriteProjectId}';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: Colors.white,
      shape: AppStyles.cardShape,
      child: ListTile(
        onTap: () => launchUrl(Uri.parse(url)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppStyles.primaryOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.picture_as_pdf_outlined, color: AppStyles.primaryOrange),
        ),
        title: Text(title, style: AppStyles.subTitleStyle),
        trailing: const Icon(Icons.download_outlined, color: AppStyles.borderColor),
      ),
    );
  }
}

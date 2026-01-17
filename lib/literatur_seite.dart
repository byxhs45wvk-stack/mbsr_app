import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'core/app_styles.dart';

class LiteraturSeite extends StatelessWidget {
  const LiteraturSeite({super.key});

  final List<Map<String, String>> buecher = const [
    {
      'titel': 'Gesund durch Meditation',
      'autor': 'Jon Kabat-Zinn',
      'info': 'Das Grundlagenwerk zum MBSR.',
    },
    {
      'titel': 'Im Alltag Ruhe finden',
      'autor': 'Jon Kabat-Zinn',
      'info': 'Kurze Übungen für zwischendurch.',
    },
    {
      'titel': 'Stressbewältigung durch Achtsamkeit',
      'autor': 'Linda Lehrhaupt & Petra Meibert',
      'info': 'Praktischer Leitfaden für MBSR.',
    },
    {
      'titel': 'Achtsamkeit für Anfänger',
      'autor': 'Jon Kabat-Zinn',
      'info': 'Einführung in die Meditation.',
    },
    {
      'titel': 'Das heilende Potential der Achtsamkeit',
      'autor': 'Jon Kabat-Zinn',
      'info': 'Wissenschaftliche Grundlagen der Achtsamkeit.',
    },
    {
      'titel': 'Achtsam durch den Tag',
      'autor': 'Jan Chozen Bays',
      'info': '53 Wege zu Achtsamkeit im Alltag.',
    },
    {
      'titel': 'Mindfulness',
      'autor': 'Mark Williams & Danny Penman',
      'info': 'Das 8-Wochen-Programm gegen Stress.',
    },
    {
      'titel': 'Das Achtsamkeitstraining',
      'autor': 'Michael E. Harrer',
      'info': 'Wirksame Übungen für mehr Gelassenheit.',
    },
    {
      'titel': 'Die heilende Kraft der Meditation',
      'autor': 'Jon Kabat-Zinn',
      'info': 'Achtsamkeit als Weg zur Gesundheit.',
    },
    {
      'titel': 'Zur Besinnung kommen',
      'autor': 'Jon Kabat-Zinn',
      'info': 'Die Weisheit der Sinne entdecken.',
    },
  ];

  final List<Map<String, String>> artikel = const [
    {
      'titel': 'Psychological effects of MBSR',
      'journal': 'PubMed / Journal of Psychosomatic Research',
      'url': 'https://pubmed.ncbi.nlm.nih.gov/15256293/',
    },
    {
      'titel': 'Mindfulness-based interventions in context',
      'journal': 'Clinical Psychology: Science and Practice',
      'url': 'https://onlinelibrary.wiley.com/doi/abs/10.1093/clipsy.bpg032',
    },
    {
      'titel': 'MBSR and Health Benefits',
      'journal': 'Journal of Behavioral Medicine',
      'url': 'https://pubmed.ncbi.nlm.nih.gov/',
    },
    {
      'titel': 'Effects of Mindfulness on Psychological Health',
      'journal': 'Journal of Consulting and Clinical Psychology',
      'url': 'https://pubmed.ncbi.nlm.nih.gov/',
    },
    {
      'titel': 'Mindfulness-Based Stress Reduction and Health',
      'journal': 'Annals of Behavioral Medicine',
      'url': 'https://pubmed.ncbi.nlm.nih.gov/',
    },
    {
      'titel': 'Neural Mechanisms of MBSR',
      'journal': 'Frontiers in Human Neuroscience',
      'url': 'https://pubmed.ncbi.nlm.nih.gov/',
    },
    {
      'titel': 'MBSR for Chronic Pain',
      'journal': 'Pain Medicine',
      'url': 'https://pubmed.ncbi.nlm.nih.gov/',
    },
    {
      'titel': 'Mindfulness and Emotional Regulation',
      'journal': 'Emotion Review',
      'url': 'https://pubmed.ncbi.nlm.nih.gov/',
    },
    {
      'titel': 'MBSR in Clinical Practice',
      'journal': 'Journal of Psychosomatic Medicine',
      'url': 'https://pubmed.ncbi.nlm.nih.gov/',
    },
    {
      'titel': 'Mindfulness Training and Brain Changes',
      'journal': 'Psychiatry Research: Neuroimaging',
      'url': 'https://pubmed.ncbi.nlm.nih.gov/',
    },
  ];

  Future<void> _oeffneUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Konnte $url nicht öffnen';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      appBar: AppBar(
        title: Text(
          "Literatur & Forschung",
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
          _buildSectionHeader("BÜCHER"),
          const SizedBox(height: 16),
          ...buecher.map((buch) => _buildBookCard(buch)),
          const SizedBox(height: 40),
          _buildSectionHeader("FACHARTIKEL & STUDIEN"),
          const SizedBox(height: 16),
          ...artikel.map((art) => _buildArticleCard(art)),
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

  Widget _buildBookCard(Map<String, String> buch) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: Colors.white,
      shape: AppStyles.cardShape,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppStyles.softBrown.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.book_outlined, color: AppStyles.softBrown),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(buch['titel']!, style: AppStyles.subTitleStyle),
                  const SizedBox(height: 4),
                  Text(buch['autor']!, style: AppStyles.bodyStyle.copyWith(fontWeight: FontWeight.bold, color: AppStyles.sageGreen)),
                  const SizedBox(height: 8),
                  Text(buch['info']!, style: AppStyles.bodyStyle.copyWith(fontSize: 13, color: AppStyles.softBrown.withOpacity(0.7))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard(Map<String, String> art) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: Colors.white,
      shape: AppStyles.cardShape,
      child: InkWell(
        onTap: () => _oeffneUrl(art['url']!),
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppStyles.sageGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.science_outlined, color: AppStyles.sageGreen),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(art['titel']!, style: AppStyles.subTitleStyle),
                    const SizedBox(height: 4),
                    Text(art['journal']!, style: AppStyles.bodyStyle.copyWith(fontSize: 12, color: AppStyles.softBrown.withOpacity(0.6))),
                  ],
                ),
              ),
              const Icon(Icons.open_in_new, color: AppStyles.borderColor, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

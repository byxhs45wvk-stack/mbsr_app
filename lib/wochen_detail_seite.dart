import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'services/connectivity_service.dart';
import 'core/app_config.dart';
import 'core/app_styles.dart';
import 'widgets/decorative_blobs.dart';

class WochenDetailSeite extends StatefulWidget {
  final String wochenNummer;
  final String titel;
  final List<Map<String, String>> audios;
  final List<Map<String, String>> pdfs;
  final List<String> wochenAufgaben;

  const WochenDetailSeite({
    super.key,
    required this.wochenNummer,
    required this.titel,
    required this.audios,
    required this.pdfs,
    this.wochenAufgaben = const [],
  });

  @override
  State<WochenDetailSeite> createState() => _WochenDetailSeiteState();
}

class _WochenDetailSeiteState extends State<WochenDetailSeite> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      appBar: AppBar(
        title: Text(
          widget.wochenNummer,
          style: AppStyles.headingStyle.copyWith(fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppStyles.softBrown,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: DecorativeBlobs(
        child: Column(
          children: [
            // Offline-Banner
            StreamBuilder<bool>(
              stream: ConnectivityService.onlineStream,
              initialData: ConnectivityService.isOnline,
              builder: (context, snapshot) {
                final isOnline = snapshot.data ?? true;
                if (isOnline) return const SizedBox.shrink();

                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off,
                        size: 18,
                        color: Colors.orange.shade800,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Offline - Audios können nicht geladen werden',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange.shade900,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  AppStyles.spacingL,
                  AppStyles.spacingS,
                  AppStyles.spacingL,
                  150,
                ), // Platz für globalen Player
                children: [
                  Text(widget.titel, style: AppStyles.titleStyle),
                  AppStyles.spacingXLBox,

                  // Wochenaufgaben Sektion
                  if (widget.wochenAufgaben.isNotEmpty) ...[
                    Container(
                      padding: AppStyles.cardPadding,
                      decoration: BoxDecoration(
                        color: AppStyles.primaryOrange.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: AppStyles.primaryOrange.withOpacity(0.1),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.assignment_outlined,
                                color: AppStyles.primaryOrange,
                                size: 24,
                              ),
                              SizedBox(
                                width: AppStyles.spacingM - AppStyles.spacingS,
                              ), // 12px
                              Text(
                                "Deine Übungen",
                                style: AppStyles.headingStyle.copyWith(
                                  fontSize: 18,
                                  color: AppStyles.primaryOrange,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: AppStyles.spacingL - AppStyles.spacingS,
                          ), // 20px
                          ...widget.wochenAufgaben.map(
                            (aufgabe) => Padding(
                              padding: EdgeInsets.only(
                                bottom: AppStyles.spacingM,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 2),
                                    child: const Icon(
                                      Icons.check_circle_outline,
                                      color: AppStyles.sageGreen,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        AppStyles.spacingM - AppStyles.spacingS,
                                  ), // 12px
                                  Expanded(
                                    child: Text(
                                      aufgabe,
                                      style: AppStyles.bodyStyle.copyWith(
                                        height: 1.6,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: AppStyles.spacingXL + AppStyles.spacingS,
                    ), // 40px
                  ],

                  if (widget.pdfs.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 16),
                      child: Text(
                        "UNTERLAGEN",
                        style: AppStyles.bodyStyle.copyWith(
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: AppStyles.softBrown.withOpacity(0.5),
                        ),
                      ),
                    ),
                    ...widget.pdfs.map((pdf) => _buildPdfCard(pdf)),
                    const SizedBox(height: 40),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPdfCard(Map<String, String> pdf) {
    final appwriteId = pdf['appwrite_id'];
    final url =
        '${AppConfig.appwriteEndpoint}/storage/buckets/${AppConfig.pdfsBucketId}/files/$appwriteId/view?project=${AppConfig.appwriteProjectId}';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: Colors.white,
      shape: AppStyles.cardShape,
      child: InkWell(
        onTap: () => launchUrl(Uri.parse(url)),
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppStyles.softBrown.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: AppStyles.softBrown,
                  size: 28,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(pdf['title']!, style: AppStyles.subTitleStyle),
              ),
              const Icon(
                Icons.open_in_new,
                color: AppStyles.borderColor,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

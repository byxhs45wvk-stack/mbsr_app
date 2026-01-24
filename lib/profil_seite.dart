import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'pages/home_page.dart';
import 'statistiken_seite.dart';
import 'audio_service.dart';
import 'legal_dialogs.dart';
import 'core/app_styles.dart';
import 'widgets/decorative_blobs.dart';

class ProfilSeite extends StatelessWidget {
  const ProfilSeite({super.key});

  static Future<void> _signOut(BuildContext context) async {
    // Bestätigungsdialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Abmelden",
            style: AppStyles.headingStyle,
          ),
          content: Text(
            "Möchtest du dich wirklich abmelden?",
            style: AppStyles.bodyStyle,
          ),
          backgroundColor: AppStyles.bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyles.borderRadius),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                "Abbrechen",
                style: AppStyles.bodyStyle.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.primaryOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text("Abmelden"),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return; // Benutzer hat abgebrochen
    }

    try {
      // Audio stoppen bevor wir uns abmelden
      await AudioService().stop();
      
      // Logout über Appwrite Auth-Service
      await AuthService().logout();

      // Wir löschen alle Routen und gehen zurück zum Auswahlbereich (MBSRHomePage)
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MBSRHomePage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Fehler beim Abmelden: $e"),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;

    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      appBar: AppBar(
        title: Text(
          "Profil",
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
      body: DecorativeBlobs(
        child: ListView(
          padding: AppStyles.listPadding,
          children: [
          // Profil-Header
          Center(
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppStyles.primaryOrange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, size: 50, color: AppStyles.primaryOrange),
                ),
                SizedBox(height: AppStyles.spacingL - AppStyles.spacingS), // 20px
                Text(
                  user?.email ?? "Kein Benutzer",
                  style: AppStyles.headingStyle.copyWith(fontSize: 18),
                ),
              ],
            ),
          ),
          SizedBox(height: AppStyles.spacingXL + AppStyles.spacingS), // 40px
          // Funktionen
          Padding(
            padding: EdgeInsets.only(left: AppStyles.spacingS, bottom: AppStyles.spacingM - AppStyles.spacingS), // 12px
            child: Text(
              "FUNKTIONEN",
              style: AppStyles.bodyStyle.copyWith(
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppStyles.softBrown.withOpacity(0.5),
              ),
            ),
          ),
          // Statistiken
          Card(
            margin: EdgeInsets.only(bottom: AppStyles.spacingM),
            elevation: 0,
            color: Colors.white,
            shape: AppStyles.cardShape,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StatistikenSeite(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(AppStyles.borderRadius),
              child: Padding(
                padding: AppStyles.cardPadding,
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppStyles.sageGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.bar_chart_outlined,
                        color: AppStyles.sageGreen,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: AppStyles.spacingL - AppStyles.spacingS), // 20px
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Statistiken",
                            style: AppStyles.subTitleStyle,
                          ),
                          AppStyles.spacingXSBox,
                          Text(
                            "Deine Praxis im Überblick",
                            style: AppStyles.bodyStyle.copyWith(fontSize: 13, color: AppStyles.softBrown.withOpacity(0.6)),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppStyles.borderColor),
                  ],
                ),
              ),
            ),
          ),
          AppStyles.spacingXLBox,
          // Abmelden
          ElevatedButton.icon(
            onPressed: () => _signOut(context),
            icon: const Icon(Icons.logout),
            label: const Text("Abmelden"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppStyles.primaryOrange,
              elevation: 0,
              side: BorderSide(color: AppStyles.primaryOrange.withOpacity(0.3), width: 1.5),
              padding: EdgeInsets.symmetric(vertical: AppStyles.spacingM),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          SizedBox(height: AppStyles.spacingXL + AppStyles.spacingS), // 40px
          // Footer: Impressum & Datenschutz (dezente kleine Links)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => LegalDialogs.showImpressum(context),
                child: Text(
                  'Impressum',
                  style: AppStyles.bodyStyle.copyWith(fontSize: 12, color: AppStyles.softBrown.withOpacity(0.5)),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppStyles.spacingM - AppStyles.spacingS), // 12px
                child: Text(
                  '•',
                  style: TextStyle(color: AppStyles.softBrown.withOpacity(0.3)),
                ),
              ),
              GestureDetector(
                onTap: () => LegalDialogs.showDatenschutz(context),
                child: Text(
                  'Datenschutz',
                  style: AppStyles.bodyStyle.copyWith(fontSize: 12, color: AppStyles.softBrown.withOpacity(0.5)),
                ),
              ),
            ],
          ),
          SizedBox(height: AppStyles.spacingXL + AppStyles.spacingS), // 40px
        ],
        ),
      ),
    );
  }
}

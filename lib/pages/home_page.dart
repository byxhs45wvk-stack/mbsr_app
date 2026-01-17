import 'package:flutter/material.dart';
import '../login_screen.dart';
import '../legal_dialogs.dart';
import '../core/app_styles.dart';

/// Landing Page mit Auswahl zwischen Stressprävention und MBSR Kursbereich
class MBSRHomePage extends StatelessWidget {
  const MBSRHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              const Spacer(),
              const Icon(
                Icons.self_improvement,
                size: 120,
                color: AppStyles.primaryOrange,
              ),
              const SizedBox(height: 40),
              Text(
                'Willkommen bei deinem Training',
                textAlign: TextAlign.center,
                style: AppStyles.titleStyle.copyWith(fontSize: 26),
              ),
              const SizedBox(height: 16),
              Text(
                'Melde dich mit deinen persönlichen Zugangsdaten an.',
                textAlign: TextAlign.center,
                style: AppStyles.bodyStyle.copyWith(
                  fontSize: 16,
                  color: AppStyles.softBrown.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 60),
              // Direkter Login-Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.primaryOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Zum Kursbereich',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              // Footer mit Impressum und Datenschutz
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
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
                      padding: const EdgeInsets.symmetric(horizontal: 12),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

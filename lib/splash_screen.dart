import 'package:flutter/material.dart';
import 'dart:async';
import 'widgets/ambient_background.dart';
import 'core/app_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  double _scale = 0.85;

  @override
  void initState() {
    super.initState();
    // Fade-In Animation starten
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
          _scale = 1.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      body: AmbientBackground(
        child: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeInOut,
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutBack,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Symbol / Logo-Ersatz
                Icon(
                  Icons.spa_outlined,
                  size: 80,
                  color: AppStyles.primaryOrange,
                ),
                SizedBox(height: AppStyles.spacingL - AppStyles.spacingS), // 20px

                // Haupttitel
                Text(
                  "Achtsamkeitstraining",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                    color: AppStyles.textDark,
                    letterSpacing: 1.2,
                  ),
                ),

                // Dein Name
                Text(
                  "Dr. Christian Hahn",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppStyles.successGreen,
                    letterSpacing: 1.0,
                ),
              ),

              SizedBox(height: AppStyles.spacingXL + AppStyles.spacingS), // 40px

              // Die drei Begriffe (Unterschrift)
                Text(
                  "Präsenz • Verbundenheit • Mitgefühl",
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: AppStyles.textDark.withOpacity(0.7),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }
}

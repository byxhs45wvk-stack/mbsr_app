import 'package:flutter/material.dart';
import 'dart:async';

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
    Future.delayed(const Duration(milliseconds: 500), () {
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
      backgroundColor: const Color(
        0xFFFAF8F5,
      ), // Warmes Beige (erdiges Farbschema)
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 1800),
          curve: Curves.easeInOut,
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 1800),
            curve: Curves.easeOutBack,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Symbol / Logo-Ersatz
                const Icon(
                  Icons.spa_outlined,
                  size: 80,
                  color: Color(0xFF8B7565), // Erdiger Braunton
                ),
                const SizedBox(height: 20),

                // Haupttitel
                const Text(
                  "Achtsamkeitstraining",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF8B7565), // Erdiger Braunton
                    letterSpacing: 1.2,
                  ),
                ),

                // Dein Name
                const Text(
                  "Dr. Christian Hahn",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7A8B6F), // Olivgrün
                    letterSpacing: 1.0,
                  ),
                ),

                const SizedBox(height: 40),

                // Die drei Begriffe (Unterschrift)
                const Text(
                  "Präsenz • Verbundenheit • Mitgefühl",
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF8B7565), // Erdiger Braunton
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

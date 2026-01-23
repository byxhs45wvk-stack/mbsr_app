import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/app_styles.dart';

/// Dekorative Blob-Formen für die Hauptseite
/// 
/// Erstellt leichte, organische Formen im Hintergrund
/// für einen modernen, lebendigen Look
class DecorativeBlobs extends StatelessWidget {
  final Widget child;
  
  const DecorativeBlobs({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dekorative Blobs im Hintergrund
        Positioned.fill(
          child: CustomPaint(
            painter: _BlobPainter(),
          ),
        ),
        // Inhalt darüber
        child,
      ],
    );
  }
}

class _BlobPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Blob 1 - Links oben (Korallenrot)
    final paint1 = Paint()
      ..color = AppStyles.primaryOrange.withOpacity(0.12)
      ..style = PaintingStyle.fill;
    
    final path1 = Path();
    path1.moveTo(size.width * 0.1, size.height * 0.15);
    path1.quadraticBezierTo(
      size.width * 0.25, size.height * 0.05,
      size.width * 0.4, size.height * 0.1,
    );
    path1.quadraticBezierTo(
      size.width * 0.5, size.height * 0.15,
      size.width * 0.35, size.height * 0.25,
    );
    path1.quadraticBezierTo(
      size.width * 0.2, size.height * 0.3,
      size.width * 0.1, size.height * 0.15,
    );
    path1.close();
    canvas.drawPath(path1, paint1);

    // Blob 2 - Rechts oben (Türkis)
    final paint2 = Paint()
      ..color = AppStyles.successGreen.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    
    final path2 = Path();
    path2.moveTo(size.width * 0.85, size.height * 0.12);
    path2.quadraticBezierTo(
      size.width * 0.95, size.height * 0.08,
      size.width * 0.9, size.height * 0.2,
    );
    path2.quadraticBezierTo(
      size.width * 0.88, size.height * 0.28,
      size.width * 0.75, size.height * 0.25,
    );
    path2.quadraticBezierTo(
      size.width * 0.8, size.height * 0.15,
      size.width * 0.85, size.height * 0.12,
    );
    path2.close();
    canvas.drawPath(path2, paint2);

    // Blob 3 - Unten links (Pink)
    final paint3 = Paint()
      ..color = AppStyles.accentPink.withOpacity(0.08)
      ..style = PaintingStyle.fill;
    
    final path3 = Path();
    path3.moveTo(size.width * 0.05, size.height * 0.7);
    path3.quadraticBezierTo(
      size.width * 0.15, size.height * 0.65,
      size.width * 0.25, size.height * 0.75,
    );
    path3.quadraticBezierTo(
      size.width * 0.3, size.height * 0.82,
      size.width * 0.2, size.height * 0.88,
    );
    path3.quadraticBezierTo(
      size.width * 0.1, size.height * 0.85,
      size.width * 0.05, size.height * 0.7,
    );
    path3.close();
    canvas.drawPath(path3, paint3);

    // Blob 4 - Unten rechts (Cyan)
    final paint4 = Paint()
      ..color = AppStyles.accentCyan.withOpacity(0.09)
      ..style = PaintingStyle.fill;
    
    final path4 = Path();
    path4.moveTo(size.width * 0.7, size.height * 0.8);
    path4.quadraticBezierTo(
      size.width * 0.85, size.height * 0.75,
      size.width * 0.92, size.height * 0.85,
    );
    path4.quadraticBezierTo(
      size.width * 0.95, size.height * 0.92,
      size.width * 0.82, size.height * 0.95,
    );
    path4.quadraticBezierTo(
      size.width * 0.75, size.height * 0.9,
      size.width * 0.7, size.height * 0.8,
    );
    path4.close();
    canvas.drawPath(path4, paint4);
  }

  @override
  bool shouldRepaint(_BlobPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';
import '../core/app_styles.dart';

/// Subtiler Divider (0.5px, 10% Opacity)
/// 
/// Beispiel:
/// ```dart
/// SubtleDivider()
/// ```
class SubtleDivider extends StatelessWidget {
  final double? height;
  final double? verticalMargin;

  const SubtleDivider({
    super.key,
    this.height,
    this.verticalMargin,
  });

  @override
  Widget build(BuildContext context) {
    return AppStyles.buildSubtleDivider(
      height: height,
    );
  }
}

/// Moderne Alternative: Whitespace statt Linie
/// 
/// Beispiel:
/// ```dart
/// SpacingDivider()
/// ```
class SpacingDivider extends StatelessWidget {
  const SpacingDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return AppStyles.buildSpacingDivider();
  }
}

import 'package:flutter/material.dart';
import '../core/app_styles.dart';

/// Wiederverwendbares Badge-Widget für Status-Anzeigen
/// 
/// Beispiel:
/// ```dart
/// BadgeWidget(
///   text: "Neu",
///   color: AppStyles.primaryOrange,
/// )
/// ```
class BadgeWidget extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;

  const BadgeWidget({
    super.key,
    required this.text,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppStyles.badgeHeight,
      padding: AppStyles.badgePadding,
      decoration: AppStyles.badgeDecoration(color: color),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: AppStyles.iconSizeXS,
              color: Colors.white,
            ),
            AppStyles.spacingXSHorizontal,
          ],
          Text(
            text,
            style: AppStyles.badgeTextStyle,
          ),
        ],
      ),
    );
  }
}

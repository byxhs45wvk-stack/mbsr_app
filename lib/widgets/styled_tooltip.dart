import 'package:flutter/material.dart';
import '../core/app_styles.dart';

/// Styled Tooltip mit konsistentem Design
/// 
/// Beispiel:
/// ```dart
/// StyledTooltip(
///   message: "Tippen für Details",
///   child: IconButton(...),
/// )
/// ```
class StyledTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final Duration? waitDuration;

  const StyledTooltip({
    super.key,
    required this.message,
    required this.child,
    this.waitDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      waitDuration: waitDuration ?? const Duration(milliseconds: 500),
      decoration: AppStyles.tooltipDecoration,
      textStyle: AppStyles.tooltipTextStyle,
      padding: AppStyles.tooltipPadding,
      child: child,
    );
  }
}

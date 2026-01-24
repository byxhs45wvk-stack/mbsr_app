import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_styles.dart';
import 'styled_tooltip.dart';

/// Animierter Play/Pause Button mit Haptik-Feedback
/// 
/// Zeigt eine sanfte "Atmung"-Animation beim Klick
/// und gibt haptisches Feedback für Premium-Feeling
class AnimatedPlayButton extends StatefulWidget {
  final bool isPlaying;
  final VoidCallback onPressed;
  final double size;
  final Color? color;
  final bool showShadow;

  const AnimatedPlayButton({
    super.key,
    required this.isPlaying,
    required this.onPressed,
    this.size = 56,
    this.color,
    this.showShadow = true,
  });

  @override
  State<AnimatedPlayButton> createState() => _AnimatedPlayButtonState();
}

class _AnimatedPlayButtonState extends State<AnimatedPlayButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    // Haptisches Feedback
    HapticFeedback.lightImpact();
    
    // "Atmung"-Animation
    _controller.forward().then((_) {
      _controller.reverse();
    });
    
    // Callback ausführen
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = widget.color ?? AppStyles.primaryOrange;
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              color: buttonColor,
              shape: BoxShape.circle,
              boxShadow: widget.showShadow
                  ? [
                      BoxShadow(
                        color: buttonColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ]
                  : null,
            ),
            child: IconButton(
              icon: Icon(widget.isPlaying ? Icons.pause : Icons.play_arrow),
              iconSize: widget.size * 0.5, // Kleineres Icon für bessere Proportion
              color: Colors.white,
              onPressed: _handleTap,
            ),
          ),
        );
      },
    );
  }
}

/// Animierter Icon-Button mit Haptik-Feedback
class AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double iconSize;
  final Color? color;
  final String? tooltip;

  const AnimatedIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconSize = 36,
    this.color,
    this.tooltip,
  });

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.selectionClick();
    _controller.forward().then((_) {
      _controller.reverse();
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: StyledTooltip( // Tooltip hinzugefügt
            message: widget.tooltip ?? '',
            child: IconButton(
              icon: Icon(widget.icon),
              iconSize: widget.iconSize,
              color: widget.color ?? AppStyles.softBrown,
              onPressed: _handleTap,
            ),
          ),
        );
      },
    );
  }
}

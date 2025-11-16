import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CelebrationAnimationWidget extends StatefulWidget {
  const CelebrationAnimationWidget({super.key});

  @override
  State<CelebrationAnimationWidget> createState() =>
      _CelebrationAnimationWidgetState();
}

class _CelebrationAnimationWidgetState extends State<CelebrationAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _checkmarkController;
  late AnimationController _confettiController;
  late Animation<double> _checkmarkAnimation;
  late Animation<double> _confettiAnimation;

  @override
  void initState() {
    super.initState();

    _checkmarkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _checkmarkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _checkmarkController,
      curve: Curves.elasticOut,
    ));

    _confettiAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _confettiController,
      curve: Curves.easeOut,
    ));

    // Start animations
    _checkmarkController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _confettiController.forward();
    });
  }

  @override
  void dispose() {
    _checkmarkController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      height: 25.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Confetti particles
          AnimatedBuilder(
            animation: _confettiAnimation,
            builder: (context, child) {
              return _buildConfettiParticles(colorScheme);
            },
          ),
          // Main checkmark circle
          AnimatedBuilder(
            animation: _checkmarkAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _checkmarkAnimation.value,
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: AppTheme.successLight,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.successLight.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: CustomIconWidget(
                    iconName: 'check',
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConfettiParticles(ColorScheme colorScheme) {
    final particles = List.generate(12, (index) {
      final angle = (index * 30.0) * (3.14159 / 180); // Convert to radians
      final distance = 15.w * _confettiAnimation.value;
      final x = distance * (index.isEven ? 1 : -1) * 0.8;
      final y = distance * (index % 3 == 0 ? -1 : 1) * 0.6;

      return Positioned(
        left: 50.w + x,
        top: 12.5.h + y,
        child: Transform.rotate(
          angle: angle * _confettiAnimation.value,
          child: Opacity(
            opacity: (1.0 - _confettiAnimation.value).clamp(0.0, 1.0),
            child: Container(
              width: 2.w,
              height: 2.w,
              decoration: BoxDecoration(
                color: _getParticleColor(index),
                shape: index % 2 == 0 ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: index % 2 != 0 ? BorderRadius.circular(2) : null,
              ),
            ),
          ),
        ),
      );
    });

    return Stack(children: particles);
  }

  Color _getParticleColor(int index) {
    final colors = [
      AppTheme.primaryLight,
      AppTheme.warningLight,
      AppTheme.successLight,
      AppTheme.accentLight,
    ];
    return colors[index % colors.length];
  }
}

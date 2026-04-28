import 'package:flutter/material.dart';

class LogoRevealWidget extends StatelessWidget {
  final Animation<double> wipeRevealAnimation;
  final Animation<double> scaleAnimation;
  final Animation<double> greyCircleAnimation;
  final Animation<double> textAnimation;

  const LogoRevealWidget({
    super.key,
    required this.wipeRevealAnimation,
    required this.scaleAnimation,
    required this.greyCircleAnimation,
    required this.textAnimation,
  });

  @override
  Widget build(BuildContext context) {
    // Listen to all animations that dictate internal widgets
    return AnimatedBuilder(
      animation: Listenable.merge([
        wipeRevealAnimation, 
        scaleAnimation, 
        greyCircleAnimation, 
        textAnimation
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: scaleAnimation.value,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Grey circle pops up visually dynamically (syncs with the shrink)
                  Transform.scale(
                    scale: greyCircleAnimation.value,
                    child: Opacity(
                      opacity: greyCircleAnimation.value.clamp(0.0, 1.0),
                      child: Container(
                        width: 130, // Tightly hugged radius
                        height: 130,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  
                  // Clean Logo Wipe Left to Right
                  ClipRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: wipeRevealAnimation.value,
                      child: Image.asset(
                        'Assets/Images/Monarch.png',
                        width: 250, 
                        height: 250,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
              
              // Move the text drastically closer to counter any blank PNG padding bounds
              Transform.translate(
                offset: const Offset(0, -30),
                child: Opacity(
                  opacity: textAnimation.value,
                  child: Transform.translate(
                    // Small powerful slide-up during fade
                    offset: Offset(0, 15 * (1 - textAnimation.value)),
                    child: const Text(
                      'MONARCH AI',
                      style: TextStyle(
                        fontSize: 26, // Sleek, slightly smaller size 
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

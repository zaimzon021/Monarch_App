import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class ExpandingParticlesWidget extends StatelessWidget {
  final Animation<double> particlesFadeAnimation;
  final Animation<double> expandAnimation;

  const ExpandingParticlesWidget({
    super.key,
    required this.particlesFadeAnimation,
    required this.expandAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: Listenable.merge([particlesFadeAnimation, expandAnimation]),
      builder: (context, child) {
        if (particlesFadeAnimation.value == 0) {
          return const SizedBox.shrink();
        }

        // The exact height of our water line. 
        // Starts at 250px (sitting at bottom) and surges past the top of the entire screen!
        final currentHeight = 250.0 + (expandAnimation.value * (size.height + 300));

        return Positioned(
          // Strongly anchored to the bottom. It can never leave the bottom of the screen empty!
          bottom: -50, 
          left: -50, // Bleeding edges prevents clipping visual anomalies when blurred
          right: -50,
          child: Opacity(
            opacity: particlesFadeAnimation.value,
            // This premium blur transforms the vector wave into a stunning, glowing, soft particle-gradient cloud!
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
              child: ClipPath(
                clipper: WaveClipper(
                  progress: expandAnimation.value,
                  phase: particlesFadeAnimation.value * math.pi * 2,
                ),
                child: Container(
                  height: currentHeight,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color(0xFFFF7A66), // Solid dense body
                        Color(0xFFFF9E81), // Brighter glowing crest
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Precision mathematical wave clipper
class WaveClipper extends CustomClipper<Path> {
  final double progress; 
  final double phase; 

  WaveClipper({required this.progress, required this.phase});

  @override
  Path getClip(Size size) {
    final path = Path();
    
    // Pushes the wave down mildly from the literal top bounds of the container
    // so that the blur has physical room to bleed inside the box
    final baseline = 80.0;
    
    // Noticeably aggressive wave action that flattens out precisely at screen destruction
    final amplitude = 40.0 * (1 - progress); 
    
    path.moveTo(0, size.height); // Strict anchor at bottom-left corner
    path.lineTo(0, baseline);
    
    // Draw the smooth sine wave acting as the top horizon of our container
    for (double x = 0; x <= size.width; x += 5) { // performance optimization step
      double y = baseline + math.sin((x / size.width * 2 * math.pi) + phase) * amplitude;
      path.lineTo(x, y);
    }
    
    path.lineTo(size.width, size.height); // Strict anchor at bottom-right corner
    path.close(); 
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) => 
      progress != oldClipper.progress || phase != oldClipper.phase;
}

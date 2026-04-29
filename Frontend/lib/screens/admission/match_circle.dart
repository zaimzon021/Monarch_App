import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Returns the dynamic color for a given match percentage.
Color matchColor(int percent) {
  if (percent >= 80) return const Color(0xFF16A34A); // bright green
  if (percent >= 70) return const Color(0xFF4ADE80); // normal green
  if (percent >= 50) return const Color(0xFFEAB308); // yellow
  return const Color(0xFFEF4444);                    // red
}

class MatchCirclePainter extends CustomPainter {
  final int percent;
  final Color color;

  MatchCirclePainter({required this.percent, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;
    const startAngle = -math.pi * 0.75;
    const sweepTotal = math.pi * 1.5;

    // Track background
    final trackPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle, sweepTotal, false, trackPaint,
    );

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    final sweep = sweepTotal * (percent / 100.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle, sweep, false, progressPaint,
    );
  }

  @override
  bool shouldRepaint(MatchCirclePainter old) =>
      old.percent != percent || old.color != color;
}

class MatchCircle extends StatelessWidget {
  final int percent;

  const MatchCircle({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    final color = matchColor(percent);
    return SizedBox(
      width: 66,
      height: 66,
      child: CustomPaint(
        painter: MatchCirclePainter(percent: percent, color: color),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$percent%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                'Match',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

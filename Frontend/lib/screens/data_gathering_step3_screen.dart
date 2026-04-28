import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_setup_provider.dart';
import 'data_gathering_step4_screen.dart';

class DataGatheringStep3Screen extends StatefulWidget {
  const DataGatheringStep3Screen({super.key});

  @override
  State<DataGatheringStep3Screen> createState() => _DataGatheringStep3ScreenState();
}

class _DataGatheringStep3ScreenState extends State<DataGatheringStep3Screen> {
  double _currentGpa = 3.5;

  void _submit() {
    // Suspend Data neatly in RAM Provider
    context.read<ProfileSetupProvider>().setStep3Data(_currentGpa);

    // Push into Step 4
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const DataGatheringStep4Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFFF7A66), size: 28),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Progress Bar
                    const Text(
                      '3/7',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54, 
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 0.42, 
                        backgroundColor: Colors.grey.shade200,
                        color: const Color(0xFFFF7A66),
                        minHeight: 6,
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    const Text(
                      "What's your GPA?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        color: Color(0xFF1A202C), // Extremely dark blue-grey
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Enter your current grade point average",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                    const SizedBox(height: 60),

                    // Beautiful Custom GPA Interaction Layout
                    Center(
                      child: SizedBox(
                        width: 260,
                        height: 260,
                        child: CustomPaint(
                          painter: GpaCircularRingPainter(_currentGpa),
                          child: Center(
                            child: Text(
                              _currentGpa.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                                letterSpacing: -2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Horizontal Slider Interface
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFFFF7A66),
                        inactiveTrackColor: Colors.grey.shade200,
                        trackHeight: 12.0,
                        thumbColor: Colors.white,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 16.0, elevation: 4),
                        overlayColor: const Color(0xFFFF7A66).withValues(alpha: 0.2),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
                      ),
                      child: Slider(
                        value: _currentGpa,
                        min: 0.0,
                        max: 4.0,
                        divisions: 40, // Allows increments of 0.1
                        onChanged: (newValue) {
                          setState(() {
                            _currentGpa = newValue;
                          });
                        },
                      ),
                    ),

                    // Value Markers below Slider
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("0.0", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
                          Text("4.0", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Continue Button
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF7A66), Color(0xFFFF9E81)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF7A66).withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(28),
                          onTap: _submit,
                          child: const Center(
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GpaCircularRingPainter extends CustomPainter {
  final double value; 
  
  GpaCircularRingPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeW = 24.0;

    // Background track (Solid Teal exactly as visual ref)
    final bgPaint = Paint()
      ..color = const Color(0xFF38B2AC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round;

    // Soft dropping shadow for the raw background 3D-effect under the whole ring
    canvas.drawCircle(center, radius, Paint()
        ..color = const Color(0xFF38B2AC).withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10));

    // Draw solid teal background natively
    canvas.drawCircle(center, radius, bgPaint);

    final sweepGradient = const SweepGradient(
      colors: [Color(0xFFFF7A66), Color(0xFF38B2AC)], // Gradient fading perfectly into Teal matching aesthetics
      startAngle: 0.0,
      endAngle: 2 * math.pi,
      transform: GradientRotation(-math.pi / 2),
    );

    final fgPaint = Paint()
      ..shader = sweepGradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round;

    // Paint the active mathematical progress sweep
    final sweepAngle = (value / 4.0) * (2 * math.pi);
    
    if (value > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2, // Native top initialization
        sweepAngle,
        false,
        fgPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant GpaCircularRingPainter oldDelegate) {
    return oldDelegate.value != value;
  }
}

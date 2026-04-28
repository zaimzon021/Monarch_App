import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/profile_setup_provider.dart';
import '../services/profile_service.dart';
import 'home_screen.dart';

class ProfileLoadingScreen extends StatefulWidget {
  const ProfileLoadingScreen({super.key});

  @override
  State<ProfileLoadingScreen> createState() => _ProfileLoadingScreenState();
}

class _ProfileLoadingScreenState extends State<ProfileLoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String _statusMessage = "Building your personalized roadmap";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    _processProfileCreation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _processProfileCreation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('user_email');

      if (email == null) {
        throw Exception("Authentication missing. Please restart the app.");
      }

      final provider = context.read<ProfileSetupProvider>();
      
      final payload = {
        "email": email,
        "fullName": provider.fullName,
        "location": provider.location,
        "academicLevel": provider.academicLevel,
        "gpa": provider.gpa,
        "studyDestination": provider.studyDestinations,
        "languageProficiency": provider.languageProficiency,
        "fundingType": provider.fundingType,
        "entranceExams": provider.entranceExams,
      };

      // Add a tiny artificial delay to make the beautiful loading screen visible 
      // (sometimes local nodejs is too fast!)
      await Future.delayed(const Duration(seconds: 2));

      final profileService = ProfileService();
      final userData = await profileService.createProfile(payload);

      // Successfully created profile in backend.
      // Now, physical device offline caching using SharedPreferences:
      await prefs.setString('cached_user_profile', jsonEncode(userData));

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      setState(() {
        _statusMessage = "Error: ${e.toString().replaceAll('Exception: ', '')}";
      });
      
      // If network fails, allow user to go back and try again
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.redAccent,
          )
        );
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) Navigator.of(context).pop();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background floating geometry (purely visual layout matched to image)
          Positioned(top: 150, left: 100, child: _buildDot(const Color(0xFF38B2AC).withValues(alpha: 0.4), 16)),
          Positioned(top: 250, right: 80, child: _buildTriangle(const Color(0xFF38B2AC).withValues(alpha: 0.3), 20)),
          Positioned(bottom: 150, left: 80, child: _buildDot(const Color(0xFFFF7A66).withValues(alpha: 0.4), 20)),
          Positioned(bottom: 200, right: 100, child: _buildTriangle(const Color(0xFFFF7A66).withValues(alpha: 0.3), 16, rotate: true)),
          Positioned(top: 300, left: 60, child: _buildRing(const Color(0xFF9F7AEA).withValues(alpha: 0.2), 14)),
          Positioned(bottom: 250, right: 60, child: _buildDot(const Color(0xFF9F7AEA).withValues(alpha: 0.3), 18)),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Beautiful Gradient Loading Ring
              AnimatedBuilder(
                animation: _controller,
                builder: (_, child) {
                  return Transform.rotate(
                    angle: _controller.value * 2 * math.pi,
                    child: child,
                  );
                },
                child: CustomPaint(
                  size: const Size(120, 120),
                  painter: GradientRingPainter(),
                ),
              ),
              
              const SizedBox(height: 60),
              
              const Text(
                "Analyzing\nyour profile...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                  color: Color(0xFF333A44),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Small dot indicator row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAnimatedDot(0, const Color(0xFFFF7A66)),
                  const SizedBox(width: 8),
                  _buildAnimatedDot(1, const Color(0xFF9F7AEA)),
                  const SizedBox(width: 8),
                  _buildAnimatedDot(2, const Color(0xFF38B2AC)),
                ],
              ),
              
              const SizedBox(height: 20),
              
              Text(
                _statusMessage,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildRing(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 3),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildTriangle(Color color, double size, {bool rotate = false}) {
    return Transform.rotate(
      angle: rotate ? math.pi : 0,
      child: CustomPaint(
        size: Size(size, size),
        painter: TrianglePainter(color),
      ),
    );
  }

  Widget _buildAnimatedDot(int index, Color color) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double offset = (math.sin((_controller.value * 2 * math.pi) + (index * math.pi / 2)) + 1) / 2;
        return Opacity(
          opacity: 0.3 + (0.7 * offset),
          child: Transform.scale(
            scale: 0.8 + (0.4 * offset),
            child: child,
          ),
        );
      },
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class GradientRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = const SweepGradient(
      colors: [
        Color(0xFFFF7A66), // Orange
        Color(0xFF38B2AC), // Teal
        Color(0xFFFF7A66), // Orange
      ],
      stops: [0.0, 0.5, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - paint.strokeWidth / 2;

    canvas.drawCircle(center, radius, paint);
    
    // Add subtle shadow matching image vibe
    final shadowPaint = Paint()
      ..color = const Color(0xFF38B2AC).withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(center, radius, shadowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/logo_reveal_widget.dart';
import '../widgets/expanding_particles_widget.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _wipeRevealAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _greyCircleAnimation;
  late final Animation<double> _textAnimation;
  late final Animation<double> _particlesFadeAnimation;
  late final Animation<double> _particlesExpandAnimation;
  bool _hasToken = false;

  @override
  void initState() {
    super.initState();
    _checkToken();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    // Phase 1: Logo Reveal Wipe (0.0 to 0.4)
    _wipeRevealAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeInOutCubic),
      ),
    );

    // Phase 2: Logo Shrinks sharply (0.4 to 0.6)
    _scaleAnimation = Tween<double>(begin: 1.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.6, curve: Curves.easeOutBack),
      ),
    );

    // Phase 2: Grey circle scales up and fades in, dramatically popping! (0.4 to 0.6)
    _greyCircleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.6, curve: Curves.easeOutBack),
      ),
    );

    // Phase 2: Text fades in slightly staggered (0.45 to 0.65)
    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.65, curve: Curves.easeOutQuad),
      ),
    );

    // Phase 2: Beautiful particle wave glow fades in at the bottom (0.4 to 0.6)
    _particlesFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.6, curve: Curves.easeInOut),
      ),
    );

    // Phase 4: Explosive particle expansion filling the screen (0.8 to 1.0)
    _particlesExpandAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.easeInQuint),
      ),
    );

    _controller.addStatusListener(_onAnimationStatusChanged);
    _controller.forward();
  }

  Future<void> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token != null && token.isNotEmpty) {
      _hasToken = true;
    }
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      final targetScreen = _hasToken ? const HomeScreen() : const OnboardingScreen();
      
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_onAnimationStatusChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Centered Logo and Text Elements
          Center(
            child: LogoRevealWidget(
              wipeRevealAnimation: _wipeRevealAnimation,
              scaleAnimation: _scaleAnimation,
              greyCircleAnimation: _greyCircleAnimation,
              textAnimation: _textAnimation,
            ),
          ),
          
          // Bottom Glowing Particles Wave
          ExpandingParticlesWidget(
            particlesFadeAnimation: _particlesFadeAnimation,
            expandAnimation: _particlesExpandAnimation,
          ),
        ],
      ),
    );
  }
}

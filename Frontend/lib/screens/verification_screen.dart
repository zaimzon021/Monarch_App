import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../providers/auth_provider.dart';
import 'main_layout.dart';
import 'data_gathering_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String email;
  const VerificationScreen({super.key, required this.email});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  
  int _secondsRemaining = 59;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    
    // Listen to focus changes on all boxes so we can animate the glowing gradient border
    for (var node in _focusNodes) {
      node.addListener(() {
        setState(() {}); 
      });
    }
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 59;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    // Move to next box if filled
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } 
  }

  void _onKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
      // If we press backspace on an empty field, we should jump backwards
      if (_controllers[index].text.isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
        _controllers[index - 1].clear();
      }
    }
  }

  Widget _buildOTPBox(int index) {
    final isFocused = _focusNodes[index].hasFocus;
    final hasValue = _controllers[index].text.isNotEmpty;

    return Focus(
      onKeyEvent: (node, event) {
        _onKeyEvent(event, index);
        return KeyEventResult.ignored;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        width: 72,
        height: 85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          // The magic gradient border hack: an outer container with a gradient
          gradient: isFocused
              ? const LinearGradient(
                  colors: [Color(0xFF38B2AC), Color(0xFFFF7A66)], // Teal to Orange
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                )
              : null,
          color: isFocused ? null : (hasValue ? Colors.grey.shade400 : Colors.grey.shade300),
          boxShadow: isFocused
              ? [
                  BoxShadow(
                    color: const Color(0xFF38B2AC).withValues(alpha: 0.35),
                    blurRadius: 16,
                    spreadRadius: 2,
                    offset: const Offset(-4, 4),
                  )
                ]
              : null,
        ),
        // Padding forces the inner pure white box to shrink, leaving a gradient 'stroke'
        child: Padding(
          padding: EdgeInsets.all(isFocused ? 2.5 : 1.5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF38B2AC), // Teal text for the numbers
                ),
                cursorColor: const Color(0xFF38B2AC),
                decoration: const InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                ),
                onChanged: (val) => _onChanged(val, index),
              ),
            ),
          ),
        ),
      ),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFF7A66), size: 28),
          onPressed: () => Navigator.pop(context),
        ),
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
                    const Text(
                "Enter verification\ncode",
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                  color: Color(0xFF333A44),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "We sent a code to ${widget.email}",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 50),
              
              // 4 OTP Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) => _buildOTPBox(index)),
              ),
              
              const SizedBox(height: 60),
              
              // Timer
              Center(
                child: Text(
                  "0:${_secondsRemaining.toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black45,
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Resend Text
              Center(
                child: GestureDetector(
                  onTap: _secondsRemaining == 0 ? () {
                    // Trigger your resend OTP API here later
                    _startTimer();
                  } : null,
                  child: Text(
                    "Resend code",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _secondsRemaining == 0 
                          ? const Color(0xFF38B2AC) // Bright teal when clickable
                          : Colors.teal.shade200, // Faded when on cooldown
                    ),
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Verify Button
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return Container(
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
                         )
                      ]
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(28),
                        onTap: authProvider.isLoading ? null : () async {
                          String code = _controllers.map((c) => c.text).join();
                          if (code.length == 4) {
                             final isComplete = await authProvider.verifyOtp(widget.email, code);
                             
                             if (isComplete != null && mounted) {
                                // Destroy the entire navigation stack so they can't 'back' into OTP screen
                                if (isComplete) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (_) => const MainLayout()),
                                    (route) => false,
                                  );
                                } else {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (_) => const DataGatheringScreen()),
                                    (route) => false,
                                  );
                                }
                             } else if (mounted && authProvider.errorMessage != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(authProvider.errorMessage!, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    backgroundColor: Colors.redAccent.shade400,
                                    behavior: SnackBarBehavior.floating,
                                  )
                                );
                                authProvider.clearError();
                             }
                          } else {
                             ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                 content: const Text("Please complete the 4-digit code.", style: TextStyle(fontWeight: FontWeight.bold)),
                                 backgroundColor: Colors.redAccent.shade400,
                                 behavior: SnackBarBehavior.floating,
                               )
                             );
                          }
                        },
                        child: Center(
                          child: authProvider.isLoading 
                              ? const SizedBox(
                                  width: 24, height: 24,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                                )
                              : const Text(
                                  "Verify",
                                  style: TextStyle(
                                     color: Colors.white,
                                     fontSize: 18,
                                     fontWeight: FontWeight.bold,
                                  )
                                )
                        )
                      )
                    )
                  );
                }
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

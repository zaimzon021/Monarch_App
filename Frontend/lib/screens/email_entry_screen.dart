import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'verification_screen.dart';

class EmailEntryScreen extends StatefulWidget {
  const EmailEntryScreen({super.key});

  @override
  State<EmailEntryScreen> createState() => _EmailEntryScreenState();
}

class _EmailEntryScreenState extends State<EmailEntryScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _submitEmail() async {
    final email = _emailController.text.trim();
    
    // Strict Regex Engine
    final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    
    if (email.isEmpty) {
      _showError('Please enter an email address.');
      return;
    }
    if (!emailRegex.hasMatch(email)) {
      _showError('Please enter a valid email address.');
      return;
    }

    // Call Provider Layer
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.sendOtp(email);
    
    if (success && mounted) {
      // Seamlessly navigate to the dynamic OTP collection screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VerificationScreen(email: email),
        ),
      );
    } else if (mounted) {
      if (authProvider.errorMessage != null) {
         _showError(authProvider.errorMessage!);
         authProvider.clearError(); // Wipe it so we don't spam if they just tap again
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
          onPressed: () => Navigator.of(context).pop(),
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
                "What's your\nemail?",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  color: Color(0xFF333A44),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "We'll send you a verification code",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black45,
                ),
              ),
              const SizedBox(height: 60),

              // Email Text Field
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _emailFocusNode.hasFocus 
                        ? const Color(0xFFFF7A66) 
                        : Colors.grey.shade200, 
                    width: _emailFocusNode.hasFocus ? 2.0 : 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _emailFocusNode.hasFocus 
                          ? const Color(0xFFFF7A66).withValues(alpha: 0.25)
                          : Colors.grey.shade100,
                      blurRadius: _emailFocusNode.hasFocus ? 20 : 10,
                      spreadRadius: _emailFocusNode.hasFocus ? 4 : 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 18, color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'your@email.com',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Icon(
                        Icons.email,
                        // Change icon color gracefully to match the active border glow
                        color: _emailFocusNode.hasFocus 
                            ? const Color(0xFFFF7A66) 
                            : Colors.teal.shade400,
                        size: 26,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ),

              const Spacer(),

              // Continue Button
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
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(28),
                        // Lock the button completely if making a network request
                        onTap: authProvider.isLoading ? null : _submitEmail,
                        child: Center(
                          // Show a spinning loader if it's currently fetching from nodejs!
                          child: authProvider.isLoading 
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Text(
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

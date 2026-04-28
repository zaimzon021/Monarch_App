import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_setup_provider.dart';
import 'data_gathering_step7_screen.dart';

class DataGatheringStep6Screen extends StatefulWidget {
  const DataGatheringStep6Screen({super.key});

  @override
  State<DataGatheringStep6Screen> createState() => _DataGatheringStep6ScreenState();
}

class _DataGatheringStep6ScreenState extends State<DataGatheringStep6Screen> {
  String _selectedFunding = "";

  void _submit() {
    if (_selectedFunding.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please select a funding type.", style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.redAccent.shade400,
          behavior: SnackBarBehavior.floating,
        )
      );
      return;
    }

    // Save Selection to RAM Architecture
    context.read<ProfileSetupProvider>().setStep6Data(_selectedFunding);

    // Navigate to Step 7
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const DataGatheringStep7Screen()),
    );
  }

  Widget _buildSquareCard(String title, String description, IconData icon, Color iconColor, Color bgColor, String value) {
    bool isSelected = _selectedFunding == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFunding = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? iconColor : Colors.transparent,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? iconColor.withValues(alpha: 0.3) : Colors.transparent,
              blurRadius: 15.0,
              spreadRadius: 2.0,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 64),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                height: 1.3,
              ),
            ),
          ],
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
        iconTheme: const IconThemeData(color: Color(0xFFFF7A66), size: 28),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Progress Bar UI
                    const Text(
                      '6/7',
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
                        value: 0.85, 
                        backgroundColor: Colors.grey.shade200,
                        color: const Color(0xFFFF7A66),
                        minHeight: 6,
                      ),
                    ),
                    
                    const SizedBox(height: 32),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF38B2AC).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.payments_rounded, color: Color(0xFF38B2AC), size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Financial preparation",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    const Text(
                      "How do you plan to\nfund your studies?",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                        color: Color(0xFF333A44),
                      ),
                    ),
                    
                    const SizedBox(height: 40),

                    // Side-by-side Colored Selection Cards!
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _buildSquareCard(
                              "Scholarship",
                              "Provided by institutions based on merit or need.",
                              Icons.school_rounded,
                              const Color(0xFF34A853), // Green
                              const Color(0xFFE6F4EA), // Light pastel green
                              "scholarship"
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildSquareCard(
                              "Self-funded",
                              "Using personal or family savings for expenses.",
                              Icons.account_balance_wallet_rounded,
                              const Color(0xFFEA4335), // Red/Orange
                              const Color(0xFFFCE8E6), // Light pastel red/orange
                              "self funded"
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    Center(
                      child: Text(
                        "Select your primary source of funding.",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            
            // Bottom Continue Button Area
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  )
                ]
              ),
              child: Container(
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
            ),
          ],
        ),
      ),
    );
  }
}

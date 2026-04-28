import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_setup_provider.dart';
import 'data_gathering_step3_screen.dart';

class DataGatheringStep2Screen extends StatefulWidget {
  const DataGatheringStep2Screen({super.key});

  @override
  State<DataGatheringStep2Screen> createState() => _DataGatheringStep2ScreenState();
}

class _DataGatheringStep2ScreenState extends State<DataGatheringStep2Screen> {
  String _selectedLevel = "";

  void _submit() {
    if (_selectedLevel.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please select an academic level.", style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.redAccent.shade400,
          behavior: SnackBarBehavior.floating,
        )
      );
      return;
    }

    // Save Selection to RAM Architecture
    context.read<ProfileSetupProvider>().setStep2Data(_selectedLevel);

    // Direct Navigation to the customized Step 3 GPA Form!
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const DataGatheringStep3Screen()),
    );
  }

  Widget _buildSelectionCard(String title, IconData icon, Color iconBgColor, Color borderColor) {
    bool isSelected = _selectedLevel == title;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedLevel = title;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? borderColor : Colors.grey.shade300,
              width: 2.0, // STRIKE FIX: Mathematically locked to 2px so it NEVER pushes siblings out vertically
            ),
            boxShadow: [
              BoxShadow(
                // MATHEMATICALLY VITAL FIX: Never animate the physical radius sizes to zero!
                // Keep the structural integrity of the shadow static, and strictly ONLY fade the color to transparent!
                color: isSelected ? borderColor.withValues(alpha: 0.25) : Colors.transparent,
                blurRadius: 15.0,
                spreadRadius: 2.0,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 20),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: iconBgColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(icon, color: iconBgColor, size: 28),
                ),
              ),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              const Spacer(),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Icon(Icons.check_circle_rounded, color: borderColor, size: 28),
                ),
            ],
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
                    // Top Progress Bar UI
                    const Text(
                      'Step 2/7',
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
                        value: 0.28, 
                        backgroundColor: Colors.grey.shade200,
                        color: const Color(0xFFFF7A66),
                        minHeight: 6,
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    const Text(
                      "What's your\nacademic level?",
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        color: Color(0xFF333A44),
                      ),
                    ),
                    
                    const SizedBox(height: 48),

                    // Selection Cards!
                    _buildSelectionCard(
                      "High School", 
                      Icons.school_rounded, 
                      const Color(0xFFFF7A66), // Orange bg
                      const Color(0xFFFF7A66), // Orange glow
                    ),
                    _buildSelectionCard(
                      "Undergraduate", 
                      Icons.menu_book_rounded, 
                      const Color(0xFF38B2AC), // Teal bg
                      const Color(0xFF38B2AC), // Teal glow
                    ),
                    _buildSelectionCard(
                      "Master's", 
                      Icons.account_balance_rounded, 
                      const Color(0xFF9F7AEA), // Purple bg
                      const Color(0xFF9F7AEA), // Purple glow
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

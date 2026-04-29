import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/profile_setup_provider.dart';
import '../services/profile_service.dart';
import 'profile_loading_screen.dart';

class DataGatheringStep7Screen extends StatefulWidget {
  const DataGatheringStep7Screen({super.key});

  @override
  State<DataGatheringStep7Screen> createState() => _DataGatheringStep7ScreenState();
}

class _DataGatheringStep7ScreenState extends State<DataGatheringStep7Screen> {
  final Set<String> _selectedExams = {};
  bool _isCreatingProfile = false;

  Future<void> _submit() async {
    if (_isCreatingProfile) return;
    
    setState(() => _isCreatingProfile = true);

    try {
      context.read<ProfileSetupProvider>().setStep7Data(_selectedExams.toList());
      
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('user_email');
      
      if (email == null) throw Exception("Authentication missing. Please restart the app.");
      
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
      
      final profileService = ProfileService();
      final userData = await profileService.createProfile(payload);
      
      await prefs.setString('cached_user_profile', jsonEncode(userData));

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const ProfileLoadingScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isCreatingProfile = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.redAccent,
          )
        );
      }
    }
  }

  Widget _buildExamCard(String examName, IconData icon, Color themeColor) {
    bool isSelected = _selectedExams.contains(examName);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedExams.remove(examName);
            } else {
              _selectedExams.add(examName);
            }
          });
        },
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Row(
              children: [
                // Left Colored Border Strip
                Container(
                  width: 6,
                  height: double.infinity,
                  color: themeColor,
                ),
                
                const SizedBox(width: 16),
                
                // Icon Box
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: themeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(icon, color: themeColor, size: 24),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Exam Name
                Expanded(
                  child: Text(
                    examName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ),
                
                // Custom Toggle Switch
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 56,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: isSelected ? themeColor : Colors.grey.shade300,
                  ),
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        left: isSelected ? 26 : 2,
                        top: 2,
                        bottom: 2,
                        child: Container(
                          width: 28,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: isSelected
                              ? Icon(Icons.check, color: themeColor, size: 18)
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 16),
              ],
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
                      '7/7',
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
                        value: 1.0, 
                        backgroundColor: Colors.grey.shade200,
                        color: const Color(0xFFFF7A66),
                        minHeight: 6,
                      ),
                    ),
                    
                    const SizedBox(height: 32),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: Text(
                            "Select your\nexams",
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              height: 1.1,
                              color: Color(0xFF333A44),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF9F7AEA).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.assignment_rounded, color: Color(0xFF9F7AEA), size: 28),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 48),

                    // Exam Selection List
                    _buildExamCard("CEnT-S", Icons.edit_note_rounded, const Color(0xFFFF7A66)),
                    _buildExamCard("TOLC-I", Icons.school_rounded, const Color(0xFF38B2AC)),
                    _buildExamCard("TOLC-E", Icons.menu_book_rounded, const Color(0xFF4299E1)),
                    _buildExamCard("SAT", Icons.description_rounded, const Color(0xFFECC94B)),

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
                    child: Center(
                      child: _isCreatingProfile
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

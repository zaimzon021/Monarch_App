import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admission/admission_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String _firstName = "Student";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCachedProfile();
  }

  Future<void> _loadCachedProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedProfile = prefs.getString('cached_user_profile');
      
      if (cachedProfile != null) {
        final Map<String, dynamic> userData = jsonDecode(cachedProfile);
        final fullName = userData['fullName'] ?? "Student";
        
        setState(() {
          _firstName = fullName.split(' ').first;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildJourneyCard(String title, String progress, IconData icon, List<Color> gradientColors, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 72,
                  ),
                ),
              ),
              Text(
                progress,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF7A66)))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Row(
                  children: [
                    Image.asset(
                      'Assets/Images/Monarch.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Hi, $_firstName!",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1A202C),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_none_rounded, size: 28, color: Colors.black),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  "Your Journey",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A202C),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.75,
                  children: [
                    _buildJourneyCard(
                      "Admission",
                      "10% Complete",
                      Icons.school_rounded,
                      [const Color(0xFFFF9E81), const Color(0xFFFF7A66)],
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AdmissionScreen()),
                      ),
                    ),
                    _buildJourneyCard(
                      "Pre-enrollment",
                      "0% Complete",
                      Icons.description_rounded,
                      [const Color(0xFF4FD1C5), const Color(0xFF38B2AC)],
                    ),
                    _buildJourneyCard(
                      "Visa",
                      "0% Complete",
                      Icons.flight_takeoff_rounded,
                      [const Color(0xFFB794F4), const Color(0xFF9F7AEA)],
                    ),
                    _buildJourneyCard(
                      "Scholarship",
                      "0% Complete",
                      Icons.emoji_events_rounded,
                      [const Color(0xFFF6E05E), const Color(0xFFD69E2E)],
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}

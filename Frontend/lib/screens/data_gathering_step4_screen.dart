import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_setup_provider.dart';
import 'data_gathering_step5_screen.dart';

class DataGatheringStep4Screen extends StatefulWidget {
  const DataGatheringStep4Screen({super.key});

  @override
  State<DataGatheringStep4Screen> createState() => _DataGatheringStep4ScreenState();
}

class _DataGatheringStep4ScreenState extends State<DataGatheringStep4Screen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _selectedDestinations = {};

  final List<Map<String, String>> _allDestinations = [
    {"name": "Italy", "flag": "🇮🇹"},
    {"name": "Germany", "flag": "🇩🇪"},
    {"name": "France", "flag": "🇫🇷"},
    {"name": "Netherlands", "flag": "🇳🇱"},
    {"name": "UK", "flag": "🇬🇧"},
    {"name": "USA", "flag": "🇺🇸"},
    {"name": "Canada", "flag": "🇨🇦"},
    {"name": "Australia", "flag": "🇦🇺"},
  ];

  void _submit() {
    if (_selectedDestinations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please select at least one destination to continue.", style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.redAccent.shade400,
          behavior: SnackBarBehavior.floating,
        )
      );
      return;
    }

    // Save to Provider
    context.read<ProfileSetupProvider>().setStep4Data(_selectedDestinations.toList());

    // Navigate to Step 5
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const DataGatheringStep5Screen()),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter destinations based on search query
    final filteredDestinations = _allDestinations.where((destination) {
      final name = destination['name']!.toLowerCase();
      return name.contains(_searchQuery.toLowerCase());
    }).toList();

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
                    // Top Progress Bar
                    const Text(
                      '4/7',
                      textAlign: TextAlign.left,
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
                        value: 0.57, 
                        backgroundColor: Colors.grey.shade200,
                        color: const Color(0xFFFF7A66),
                        minHeight: 6,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    const Text(
                      "Where do you want\nto study?",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        color: Color(0xFF1A202C),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) => setState(() => _searchQuery = value),
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: "Search destinations...",
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: const Icon(Icons.search, color: Color(0xFF38B2AC), size: 24),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),

                    // Destinations Grid
                    Wrap(
                      spacing: 16.0,
                      runSpacing: 16.0,
                      children: filteredDestinations.map((destination) {
                        final name = destination['name']!;
                        final flag = destination['flag']!;
                        final isSelected = _selectedDestinations.contains(name);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedDestinations.remove(name);
                              } else {
                                _selectedDestinations.add(name);
                              }
                            });
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: (MediaQuery.of(context).size.width - 48 - 16) / 2, // 2 columns
                                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFFFF7A66) : Colors.transparent,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isSelected 
                                        ? const Color(0xFFFF7A66).withValues(alpha: 0.15)
                                        : Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 15,
                                      spreadRadius: isSelected ? 4 : 0,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      flag,
                                      style: const TextStyle(fontSize: 48),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                        color: const Color(0xFF1A202C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Positioned(
                                  top: -8,
                                  right: -8,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF38B2AC), // Teal Checkmark
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                      weight: 900,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
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

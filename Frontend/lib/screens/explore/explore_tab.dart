import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'university_card.dart';
import 'university_detail_screen.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  List<dynamic> _universities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUniversities();
  }

  Future<void> _loadUniversities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedMatches = prefs.getString('cached_matched_universities');
      
      if (cachedMatches != null) {
        final decoded = jsonDecode(cachedMatches);
        
        setState(() {
          if (decoded is List) {
            _universities = decoded;
          } else if (decoded is Map && decoded.containsKey('data')) {
            _universities = decoded['data'] ?? [];
          } else if (decoded is Map && decoded.containsKey('universities')) {
            _universities = decoded['universities'] ?? [];
          } else {
            _universities = [];
          }
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _navigateToDetail(Map<String, dynamic> university) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => UniversityDetailScreen(university: university),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF7A66)))
          : CustomScrollView(
              slivers: [
                // Top Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.search, color: Color(0xFF38B2AC)),
                          hintText: "Search universities...",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),

                // Recommended Section Title
                if (_universities.isNotEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                      child: Text(
                        "Recommended for you",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E1E),
                        ),
                      ),
                    ),
                  ),

                // Recommended Horizontal List
                if (_universities.isNotEmpty)
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 300, // Increased height to prevent overflow
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                        scrollDirection: Axis.horizontal,
                        itemCount: _universities.length > 5 ? 5 : _universities.length, // Show top 5
                        itemBuilder: (context, index) {
                          return UniversityCard(
                            university: _universities[index],
                            onTap: () => _navigateToDetail(_universities[index]),
                          );
                        },
                      ),
                    ),
                  ),

                // All Universities Section Title & Chips
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "All Universities",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E1E),
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            _FilterChip(label: "Location"),
                            SizedBox(width: 8),
                            _FilterChip(label: "Ranking"),
                            SizedBox(width: 8),
                            _FilterChip(label: "Program"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // All Universities Grid
                _universities.isEmpty
                    ? const SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Text(
                              "No universities found.\nPlease complete your profile.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.55, // Taller cards for the grid to prevent bottom overflow
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return UniversityCard(
                                university: _universities[index],
                                onTap: () => _navigateToDetail(_universities[index]),
                              );
                            },
                            childCount: _universities.length,
                          ),
                        ),
                      ),
                      
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  const _FilterChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey.shade800,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }
}

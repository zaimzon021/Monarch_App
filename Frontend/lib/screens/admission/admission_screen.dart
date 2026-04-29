import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'university_match_row.dart';
import 'match_circle.dart';

class AdmissionScreen extends StatefulWidget {
  const AdmissionScreen({super.key});

  @override
  State<AdmissionScreen> createState() => _AdmissionScreenState();
}

class _AdmissionScreenState extends State<AdmissionScreen> {
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
      final cached = prefs.getString('cached_matched_universities');
      if (cached != null) {
        final decoded = jsonDecode(cached);
        List<dynamic> list = decoded is List ? decoded
            : (decoded is Map && decoded.containsKey('data') ? decoded['data'] : []);

        // Sort descending by matchPercentage
        list.sort((a, b) =>
            ((b['matchPercentage'] ?? 0) as num).compareTo((a['matchPercentage'] ?? 0) as num));

        setState(() { _universities = list; _isLoading = false; });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: CustomScrollView(
        slivers: [
          // ── Header ──
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: const Color(0xFFFF7A66),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(24, 0, 0, 16),
              title: const Text(
                "Top Universities\nFor You",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  height: 1.2,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF9E81), Color(0xFFFF7A66)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: Icon(
                      Icons.school_rounded,
                      size: 80,
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Legend Row ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _LegendDot(color: matchColor(85), label: "80%+ Excellent"),
                    const SizedBox(width: 14),
                    _LegendDot(color: matchColor(72), label: "70%+ Good"),
                    const SizedBox(width: 14),
                    _LegendDot(color: matchColor(55), label: "50%+ Fair"),
                    const SizedBox(width: 14),
                    _LegendDot(color: matchColor(30), label: "<50% Low"),
                  ],
                ),
              ),
            ),
          ),

          // ── List ──
          _isLoading
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: Color(0xFFFF7A66))),
                )
              : _universities.isEmpty
                  ? const SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.school_outlined, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text("No matches yet.\nPlease complete your profile.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey, fontSize: 15)),
                          ],
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => UniversityMatchRow(university: _universities[index]),
                          childCount: _universities.length,
                        ),
                      ),
                    ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

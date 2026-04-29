import 'package:flutter/material.dart';
import 'university_detail_widgets.dart';
import '../admission/application_requirements_screen.dart';


class UniversityDetailScreen extends StatelessWidget {
  final Map<String, dynamic> university;

  const UniversityDetailScreen({super.key, required this.university});

  String _formatLanguages(dynamic reqs) {
    if (reqs == null || reqs is! Map) return "English, Local";
    List<String> langs = [];
    if (reqs.containsKey('ielts')) langs.add("IELTS ${reqs['ielts']}+");
    if (reqs.containsKey('toefl')) langs.add("TOEFL ${reqs['toefl']}+");
    return langs.isNotEmpty ? langs.join(', ') : "English, Local";
  }

  @override
  Widget build(BuildContext context) {
    final String name = university['name'] ?? 'Unknown University';
    final String location = university['location'] ?? 'Unknown Location';
    final String imageUrl = university['imageUrl'] ?? 'https://via.placeholder.com/400';
    final int rank = university['worldRank'] ?? 0;
    final int acceptanceRate = university['acceptanceRate'] ?? 0;
    final List<dynamic> programs = university['programs'] ?? [];
    final String tuition = university['tuitionFee'] ?? 'Not available';
    final String admissionChance = university['admissionChance'] ?? 'Target';
    final dynamic langReqs = university['languageRequirements'];

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Header Image with Back Button
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: const Color(0xFF1A202C),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300),
              ),
            ),
          ),

          // Navy Banner
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF1A202C),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFF38B2AC), size: 16),
                      const SizedBox(width: 6),
                      Text(location, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Stats Row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StatItem(label: "World Rank", value: "#$rank"),
                  StatItem(label: "Acceptance", value: "$acceptanceRate%"),
                  StatItem(label: "Programs", value: "${programs.length}+"),
                ],
              ),
            ),
          ),

          // Info Cards Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                InfoCard(
                  icon: Icons.payments_outlined,
                  title: "Tuition fees",
                  subtitle: tuition,
                  gradientColors: const [Color(0xFFFF9E81), Color(0xFFFF7A66)],
                ),
                InfoCard(
                  icon: Icons.fact_check_outlined,
                  title: "Your Chance",
                  subtitle: admissionChance,
                  gradientColors: const [Color(0xFF4FD1C5), Color(0xFF38B2AC)],
                ),
                InfoCard(
                  icon: Icons.chat_bubble_outline,
                  title: "Language",
                  subtitle: _formatLanguages(langReqs),
                  gradientColors: const [Color(0xFFB794F4), Color(0xFF9F7AEA)],
                ),
              ],
            ),
          ),

          // Programs Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Programs Available",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E)),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 12,
                    children: programs.map((p) => ProgramChip(label: p.toString())).toList(),
                  ),
                ],
              ),
            ),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 100)), // Space for sticky button
        ],
      ),
      
      // Apply Now Sticky Bottom Button
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              colors: [Color(0xFFFF9E81), Color(0xFFFF7A66)],
            ),
            boxShadow: [
              BoxShadow(color: const Color(0xFFFF7A66).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: () {
                final passedUniId = university['_id']?.toString() ?? university['id']?.toString() ?? university['uniId']?.toString() ?? 'uni_001';
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ApplicationRequirementsScreen(
                      uniId: passedUniId,
                      universityData: university,
                    ),
                  ),
                );
              },
              child: const Center(
                child: Text(
                  "Apply Now",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

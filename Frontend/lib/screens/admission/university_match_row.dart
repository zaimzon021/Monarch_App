import 'package:flutter/material.dart';
import 'match_circle.dart';
import 'university_admission_detail_screen.dart';

class UniversityMatchRow extends StatelessWidget {
  final Map<String, dynamic> university;

  const UniversityMatchRow({super.key, required this.university});

  Color _monogramColor(String name) {
    final double hue = (name.hashCode % 360).toDouble();
    return HSVColor.fromAHSV(1.0, hue, 0.65, 0.8).toColor();
  }

  String _initials(String name) {
    final words = name.trim().split(RegExp(r'\s+')).where(
      (w) => !['di', 'of', 'the', 'and'].contains(w.toLowerCase())
    ).toList();
    if (words.isEmpty) return "U";
    if (words.length == 1) return words[0][0].toUpperCase();
    return (words[0][0] + words[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final String name = university['name'] ?? 'Unknown University';
    final String location = university['location'] ?? '';
    final int match = (university['matchPercentage'] ?? 0) as int;
    final String imageUrl = university['imageUrl'] ?? '';

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        admissionDetailRoute(university),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            // University Image Avatar (same imageUrl as detail screen)
            CircleAvatar(
              radius: 28,
              backgroundColor: _monogramColor(name),
              backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
              onBackgroundImageError: imageUrl.isNotEmpty
                  ? (_, __) {} // silently fall back to child
                  : null,
              child: imageUrl.isEmpty
                  ? Text(
                      _initials(name),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 14),

            // Name & Location
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF1E1E1E),
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 13, color: Colors.grey.shade500),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Match Circle
            MatchCircle(percent: match),

            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400, size: 22),
          ],
        ),
      ),
    );
  }
}

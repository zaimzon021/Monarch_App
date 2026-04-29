import 'package:flutter/material.dart';

class UniversityCard extends StatefulWidget {
  final Map<String, dynamic> university;
  final VoidCallback onTap;

  const UniversityCard({
    super.key,
    required this.university,
    required this.onTap,
  });

  @override
  State<UniversityCard> createState() => _UniversityCardState();
}

class _UniversityCardState extends State<UniversityCard> {
  bool _isTapped = false;

  Color _getAcceptanceRateColor(int rate) {
    if (rate < 20) return const Color(0xFFFF6B6B); // Red for highly selective
    if (rate <= 40) return const Color(0xFFFCA311); // Orange for competitive
    return const Color(0xFF38B2AC); // Green for accessible
  }

  void _handleTap() async {
    setState(() => _isTapped = true);
    await Future.delayed(const Duration(milliseconds: 150));
    widget.onTap();
    if (mounted) setState(() => _isTapped = false);
  }

  Color _getMonogramColor(String name) {
    final int hash = name.hashCode;
    final double hue = (hash % 360).toDouble();
    return HSVColor.fromAHSV(1.0, hue, 0.65, 0.85).toColor();
  }

  String _getInitials(String name) {
    List<String> words = name.trim().split(RegExp(r'\s+'));
    // Filter out common connective words for better initials
    words = words.where((w) => w.toLowerCase() != 'di' && w.toLowerCase() != 'of' && w.toLowerCase() != 'the' && w.toLowerCase() != 'and').toList();
    
    if (words.isEmpty) return "U";
    if (words.length == 1) return words[0].isNotEmpty ? words[0].substring(0, 1).toUpperCase() : "U";
    
    return (words[0].substring(0, 1) + words[1].substring(0, 1)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final String name = widget.university['name'] ?? 'Unknown University';
    final String location = widget.university['location'] ?? 'Unknown Location';
    final int acceptanceRate = widget.university['acceptanceRate'] ?? 0;
    final String imageUrl = widget.university['imageUrl'] ?? 'https://via.placeholder.com/150';

    return GestureDetector(
      onTap: _handleTap,
      onTapDown: (_) => setState(() => _isTapped = true),
      onTapUp: (_) => setState(() => _isTapped = false),
      onTapCancel: () => setState(() => _isTapped = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 180, // Fixed width for horizontal list
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isTapped ? const Color(0xFFFF7A66) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image and Logo Stack
            SizedBox(
              height: 110, // Slightly reduced to prevent overflow
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: 110,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: double.infinity,
                        height: 110,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.school, color: Colors.white, size: 40),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -20,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: _getMonogramColor(name),
                        child: Text(
                          _getInitials(name),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 24), // Space for overlapping logo
            
            // Details
            Expanded( // Use Expanded to handle dynamic text sizing and prevent overflow
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(), // Pushes the badge to the bottom
                    
                    // Dynamic Acceptance Rate Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getAcceptanceRateColor(acceptanceRate),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Acceptance Rate: $acceptanceRate%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
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

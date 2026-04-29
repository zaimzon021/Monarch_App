import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../splash_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  Map<String, dynamic>? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString('cached_user_profile');
      if (cached != null) {
        final decoded = jsonDecode(cached);
        setState(() {
          _profile = (decoded is Map && decoded.containsKey('data'))
              ? Map<String, dynamic>.from(decoded['data'])
              : Map<String, dynamic>.from(decoded);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out', style: TextStyle(color: Color(0xFFFF7A66), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('jwt_token');
      await prefs.remove('user_email');
      await prefs.remove('cached_user_profile');
      await prefs.remove('cached_matched_universities');

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const SplashScreen()),
          (route) => false,
        );
      }
    }
  }

  Color _avatarColor(String name) {
    final double hue = (name.hashCode.abs() % 360).toDouble();
    return HSVColor.fromAHSV(1.0, hue, 0.6, 0.75).toColor();
  }

  String _initials(String name) {
    final words = name.trim().split(RegExp(r'\s+'))
        .where((w) => !['di','of','the','and'].contains(w.toLowerCase()))
        .toList();
    if (words.isEmpty) return 'S';
    if (words.length == 1) return words[0][0].toUpperCase();
    return (words[0][0] + words[1][0]).toUpperCase();
  }

  String _tagline(String level) {
    final l = level.toLowerCase();
    if (l.contains('under') || l.contains('bachelor')) return "Let's conquer that Master's! 🎓";
    if (l.contains('master')) return "Your PhD journey starts here! 🚀";
    if (l.contains('phd') || l.contains('doctor')) return "Pushing the frontier of knowledge! 🔬";
    return "Your global education journey awaits! 🌍";
  }

  List<String> _toList(dynamic val) {
    if (val is List) return val.map((e) => e.toString().toUpperCase()).toList();
    if (val is String && val.isNotEmpty) return [val.toUpperCase()];
    return [];
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator(color: Color(0xFFFF7A66)));
    if (_profile == null) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.person_outline, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          const Text('Profile not found.', style: TextStyle(color: Colors.grey, fontSize: 16)),
        ]),
      );
    }

    final name        = _profile!['fullName']?.toString() ?? 'Student';
    final email       = _profile!['email']?.toString() ?? '';
    final location    = _profile!['location']?.toString() ?? '';
    final level       = _profile!['academicLevel']?.toString() ?? '';
    final gpa         = _profile!['gpa']?.toString() ?? 'N/A';
    final funding     = _profile!['fundingType']?.toString() ?? 'N/A';
    final destinations = _toList(_profile!['studyDestination'] ?? _profile!['studyDestinations']);
    final languages   = _toList(_profile!['languageProficiency']);
    final exams       = _toList(_profile!['entranceExams']);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          // ──── Header ────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF9E81), Color(0xFFFF7A66)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 36, 24, 36),
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      width: 86, height: 86,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _avatarColor(name),
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 16, offset: const Offset(0, 6),
                        )],
                      ),
                      alignment: Alignment.center,
                      child: Text(_initials(name), style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold,
                        fontSize: 28, letterSpacing: 2,
                      )),
                    ),
                    const SizedBox(height: 14),
                    Text(name, textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 6),
                    Text(_tagline(level), textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    if (location.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Icon(Icons.location_on, color: Colors.white70, size: 14),
                        const SizedBox(width: 4),
                        Text(location, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      ]),
                    ],
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ──── Stat Cards ────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  _StatCard(icon: Icons.grade_rounded, label: 'GPA', value: gpa,
                    colors: const [Color(0xFFFF9E81), Color(0xFFFF7A66)]),
                  const SizedBox(width: 10),
                  _StatCard(icon: Icons.school_rounded, label: 'Level', value: level,
                    colors: const [Color(0xFF4FD1C5), Color(0xFF38B2AC)]),
                  const SizedBox(width: 10),
                  _StatCard(icon: Icons.payments_rounded, label: 'Funding', value: funding,
                    colors: const [Color(0xFFB794F4), Color(0xFF9F7AEA)]),
                ],
              ),
            ),
          ),

          const SizedBox(height: 28),

          // ──── Info Card ────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 4),
                )],
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('MY PROFILE', style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.bold,
                    color: Color(0xFF9CA3AF), letterSpacing: 1.2,
                  )),
                  const SizedBox(height: 16),
                  if (email.isNotEmpty) _InfoRow(Icons.email_outlined, 'Email', email),
                  if (destinations.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _TagSection('DESTINATIONS', destinations, const Color(0xFFFF7A66)),
                  ],
                  if (exams.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _TagSection('ENTRANCE EXAMS', exams, const Color(0xFF9F7AEA)),
                  ],
                  if (exams.isEmpty) ...[
                    const SizedBox(height: 16),
                    _TagSection('ENTRANCE EXAMS', const ['NONE'], Colors.grey),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ──── Sign Out Button ────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: GestureDetector(
              onTap: _signOut,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFFF7A66), width: 1.5),
                  boxShadow: [BoxShadow(
                    color: const Color(0xFFFF7A66).withValues(alpha: 0.1),
                    blurRadius: 10, offset: const Offset(0, 4),
                  )],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, color: Color(0xFFFF7A66), size: 20),
                    SizedBox(width: 8),
                    Text('Sign Out', style: TextStyle(
                      color: Color(0xFFFF7A66),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ──── Private Widgets ────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final List<Color> colors;

  const _StatCard({required this.icon, required this.label, required this.value, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
          boxShadow: [BoxShadow(color: colors.last.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value, textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ]),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFFF7A66).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFFFF7A66), size: 18),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1E1E))),
      ])),
    ]);
  }
}

class _TagSection extends StatelessWidget {
  final String title;
  final List<String> tags;
  final Color color;
  const _TagSection(this.title, this.tags, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold,
          color: Color(0xFF9CA3AF), letterSpacing: 1.0)),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8, runSpacing: 8,
        children: tags.map((t) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
          child: Text(t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
        )).toList(),
      ),
    ]);
  }
}

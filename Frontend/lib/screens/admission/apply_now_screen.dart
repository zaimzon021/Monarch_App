import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/university_service.dart';

class ApplyNowScreen extends StatefulWidget {
  final String uniId;
  final Map<String, dynamic>? universityData;

  const ApplyNowScreen({super.key, required this.uniId, this.universityData});

  @override
  State<ApplyNowScreen> createState() => _ApplyNowScreenState();
}

class _ApplyNowScreenState extends State<ApplyNowScreen> {
  Map<String, dynamic>? _data;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final data = await UniversityService.getUniversityLink(widget.uniId);
    setState(() {
      _data = data;
      _isLoading = false;
    });
  }

  Future<void> _launchUrl() async {
    if (_data != null && _data!['applyUrl'] != null) {
      final uri = Uri.parse(_data!['applyUrl']);
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open the application link.')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Color(0xFFFF7A66))),
      );
    }

    final uniName = _data?['name'] ?? widget.universityData?['name'] ?? 'your selected university';
    
    // Safely get a background image from university data or fallback
    String imageUrl = 'https://res.cloudinary.com/dhxr1x9sx/image/upload/v1777465203/polimi_main_wkjf3l.jpg';
    if (widget.universityData != null && widget.universityData!['images'] != null) {
      final images = widget.universityData!['images'] as List;
      if (images.isNotEmpty) {
        imageUrl = images[0];
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          // Hero Image
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.2), BlendMode.darken),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.5),
                    Colors.transparent,
                    Colors.white,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7A66).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.rocket_launch_rounded, color: Color(0xFFFF7A66), size: 48),
                  ),
                  const SizedBox(height: 24),
                  
                  // Motivating text
                  const Text(
                    "You're Ready!",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "You've successfully met all the initial requirements. It's time to take the final step and apply to $uniName.",
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  
                  const Spacer(),
                  
                  // Big Apply Now Button
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF7A66), Color(0xFFFF5238)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF7A66).withValues(alpha: 0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: _launchUrl,
                        child: const Center(
                          child: Text(
                            "Apply Now",
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Review Requirements Again",
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

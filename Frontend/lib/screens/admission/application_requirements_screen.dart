import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/university_service.dart';
import 'apply_now_screen.dart';

class ApplicationRequirementsScreen extends StatefulWidget {
  final String uniId;
  final Map<String, dynamic>? universityData;

  const ApplicationRequirementsScreen({
    super.key,
    required this.uniId,
    this.universityData,
  });

  @override
  State<ApplicationRequirementsScreen> createState() => _ApplicationRequirementsScreenState();
}

class _ApplicationRequirementsScreenState extends State<ApplicationRequirementsScreen> {
  Map<String, dynamic>? _data;
  bool _isLoading = true;
  List<Map<String, dynamic>> _combinedReqs = [];
  final Set<String> _completedReqs = {};

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final data = await UniversityService.getRequirements(widget.uniId);
    
    final reqsFromApi = data?['applicationRequirements'] as List<dynamic>? ?? [];
    final double uniGpa = widget.universityData != null && widget.universityData!['requiredGpa'] != null
        ? (widget.universityData!['requiredGpa'] as num).toDouble()
        : 3.0;
    final double userGpa = 3.5;

    _combinedReqs = [
      {
        "reqId": "hardcoded_cgpa",
        "title": "CGPA Requirement",
        "type": "gpa",
        "statusOverride": "Completed. Score: $userGpa / $uniGpa",
        "generalGuide": "Your profile CGPA ($userGpa) meets or exceeds the university requirement ($uniGpa).",
        "localInstructions": "No further action is needed for this initial screening step.",
        "isRequired": true,
        "isAutoCompleted": true,
      },
      {
        "reqId": "hardcoded_lang",
        "title": "Language Proficiency",
        "type": "exam",
        "statusOverride": "Completed. English criteria met.",
        "generalGuide": "Based on your profile, your language proficiency meets the minimum criteria for this program.",
        "localInstructions": "Ensure your official test scores are ready to be dispatched if requested by the university directly.",
        "isRequired": true,
        "isAutoCompleted": true,
      },
      ...reqsFromApi.map((e) => Map<String, dynamic>.from(e)..['isAutoCompleted'] = false)
    ];

    for (var req in _combinedReqs) {
      if (req['isAutoCompleted'] == true) {
        _completedReqs.add(req['reqId']);
      }
    }

    setState(() {
      _data = data;
      _isLoading = false;
    });
  }

  void _handleCheckChanged(String reqId, bool isChecked) {
    setState(() {
      if (isChecked) {
        _completedReqs.add(reqId);
      } else {
        _completedReqs.remove(reqId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
        body: const Center(child: CircularProgressIndicator(color: Color(0xFFFF7A66))),
      );
    }

    final bool allCompleted = _completedReqs.length == _combinedReqs.length && _combinedReqs.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: const Text(
                "Requirements",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
              ),
              background: Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(left: 20, top: 60, right: 20),
                child: Text(
                  widget.universityData?['name'] ?? _data?['name'] ?? 'University',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final req = _combinedReqs[index];
                final bool isAutoCompleted = req['isAutoCompleted'] == true;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: RequirementCard(
                    requirement: req,
                    isAutoCompleted: isAutoCompleted,
                    index: index,
                    onCheckChanged: (isChecked) => _handleCheckChanged(req['reqId'], isChecked),
                  ),
                );
              },
              childCount: _combinedReqs.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)), // Space for bottom sheet
        ],
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: allCompleted
                ? const LinearGradient(colors: [Color(0xFF4ADE80), Color(0xFF22C55E)])
                : const LinearGradient(colors: [Color(0xFFD1D5DB), Color(0xFF9CA3AF)]),
            boxShadow: allCompleted
                ? [BoxShadow(color: const Color(0xFF22C55E).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))]
                : [],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: allCompleted
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ApplyNowScreen(
                            uniId: widget.uniId,
                            universityData: widget.universityData,
                          ),
                        ),
                      );
                    }
                  : null, // Null disables the splash effect
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      allCompleted ? "Continue to Apply" : "Complete Requirements",
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    if (allCompleted) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RequirementCard extends StatefulWidget {
  final Map<String, dynamic> requirement;
  final bool isAutoCompleted;
  final int index;
  final ValueChanged<bool> onCheckChanged;

  const RequirementCard({
    super.key,
    required this.requirement,
    required this.isAutoCompleted,
    required this.index,
    required this.onCheckChanged,
  });

  @override
  State<RequirementCard> createState() => _RequirementCardState();
}

class _RequirementCardState extends State<RequirementCard> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isAutoCompleted;
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _toggleCheck(bool? value) {
    if (widget.isAutoCompleted) return;
    final newVal = value ?? false;
    setState(() {
      _isChecked = newVal;
    });
    widget.onCheckChanged(newVal);
  }

  Future<void> _openMap() async {
    final loc = widget.requirement['physicalLocation'];
    if (loc != null) {
      final lat = loc['lat'];
      final lng = loc['lng'];
      final url = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
      final uri = Uri.parse(url);
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open map.')));
        }
      }
    }
  }

  Color _getBaseColor() {
    if (_isChecked) return const Color(0xFF22C55E); // Green
    final colors = [
      const Color(0xFF3B82F6), // Blue
      const Color(0xFFF59E0B), // Orange/Yellow
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFFEC4899), // Pink
      const Color(0xFF14B8A6), // Teal
    ];
    return colors[(widget.index + 2) % colors.length];
  }

  IconData _getIcon() {
    if (_isChecked) return Icons.check;
    final type = widget.requirement['type'];
    if (type == 'exam') return Icons.school;
    if (type == 'gpa') return Icons.military_tech;
    return Icons.description_outlined;
  }

  String _getStatusText() {
    if (_isChecked) {
      if (widget.requirement['statusOverride'] != null) {
        return widget.requirement['statusOverride'];
      }
      return "Completed.";
    }
    return "Pending Verification.";
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = _getBaseColor();
    final title = widget.requirement['title'] ?? 'Requirement';
    final isRequired = widget.requirement['isRequired'] == true;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Container(height: 4, color: baseColor),
            InkWell(
              onTap: _toggleExpanded,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: baseColor.withValues(alpha: _isChecked ? 1.0 : 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_getIcon(), color: _isChecked ? Colors.white : baseColor, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E)),
                          ),
                          const SizedBox(height: 4),
                          Text("Status: ${_getStatusText()}", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                          const SizedBox(height: 12),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Stack(
                                children: [
                                  Container(
                                    height: 6,
                                    width: constraints.maxWidth,
                                    decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(3)),
                                  ),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    height: 6,
                                    width: _isChecked ? constraints.maxWidth : constraints.maxWidth * 0.15,
                                    decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(3)),
                                  ),
                                ],
                              );
                            }
                          ),
                        ],
                      ),
                    ),
                    if (!widget.isAutoCompleted)
                      Checkbox(
                        value: _isChecked,
                        activeColor: const Color(0xFF22C55E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        onChanged: _toggleCheck,
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Icon(Icons.check_circle, color: Color(0xFF22C55E)),
                      ),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _isExpanded
                  ? Container(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(),
                          const SizedBox(height: 8),
                          if (isRequired)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                              child: const Text("Mandatory", style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          const SizedBox(height: 12),
                          
                          // General Guide Box
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.blue.shade100)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Icon(Icons.info_outline, size: 16, color: Colors.blue.shade700),
                                  const SizedBox(width: 8),
                                  Text("General Guide", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blue.shade900)),
                                ]),
                                const SizedBox(height: 6),
                                Text(widget.requirement['generalGuide'] ?? "", style: TextStyle(color: Colors.blue.shade900, fontSize: 13)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Local Instructions Box
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.purple.shade100)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Icon(Icons.location_on_outlined, size: 16, color: Colors.purple.shade700),
                                  const SizedBox(width: 8),
                                  Text("Local Instructions (Pakistan)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.purple.shade900)),
                                ]),
                                const SizedBox(height: 6),
                                Text(widget.requirement['localInstructions'] ?? "", style: TextStyle(color: Colors.purple.shade900, fontSize: 13)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Image Preview
                          if (widget.requirement['sampleImageUrl'] != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Sample Document", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                const SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.orange.shade200)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      widget.requirement['sampleImageUrl'],
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        height: 150,
                                        color: Colors.orange.shade100,
                                        alignment: Alignment.center,
                                        child: const Icon(Icons.broken_image, color: Colors.orange),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          
                          // Google Maps Preview Design
                          if (widget.requirement['physicalLocation'] != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Location", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: _openMap,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width: double.infinity,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey.shade300),
                                      image: const DecorationImage(
                                        image: NetworkImage("https://www.mapquestapi.com/staticmap/v5/map?key=Gmjtd%7Clu6t2lu7n9%2C22%3Do5-lzbgq&center=33.6601,73.044&zoom=14&size=600,400@2x"), 
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(30),
                                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: const Offset(0, 4))],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.network(
                                              'https://cdn-icons-png.flaticon.com/512/2991/2991231.png',
                                              height: 24,
                                              width: 24,
                                              errorBuilder: (c, e, s) => const Icon(Icons.pin_drop, color: Colors.blue),
                                            ),
                                            const SizedBox(width: 8),
                                            const Text(
                                              "Open in Google Maps",
                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

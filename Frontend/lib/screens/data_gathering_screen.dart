import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_setup_provider.dart';
import '../services/location_service.dart';
import 'data_gathering_step2_screen.dart';

class DataGatheringScreen extends StatefulWidget {
  const DataGatheringScreen({super.key});

  @override
  State<DataGatheringScreen> createState() => _DataGatheringScreenState();
}

class _DataGatheringScreenState extends State<DataGatheringScreen> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _nameFocus = FocusNode();
  final _locFocus = FocusNode();
  bool _isFetchingLocation = false;

  @override
  void initState() {
    super.initState();
    _nameFocus.addListener(() => setState(() {}));
    _locFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _nameFocus.dispose();
    _locFocus.dispose();
    super.dispose();
  }

  Future<void> _fetchLocation() async {
    setState(() => _isFetchingLocation = true);
    
    // Calls the robust backend service which triggers OS permissions organically
    final city = await LocationService.getCurrentLocation();
    
    if (!mounted) return;
    
    setState(() {
      _isFetchingLocation = false;
      if (city != null) {
        _locationController.text = city;
      }
    });

    if (city == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("You must allow location access to continue.", style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.redAccent.shade400,
          behavior: SnackBarBehavior.floating,
        )
      );
    }
  }

  void _submit() {
    if (_nameController.text.trim().isEmpty || _locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please fill in all fields", style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.redAccent.shade400,
          behavior: SnackBarBehavior.floating,
        )
      );
      return;
    }
    
    // Save to RAM across the architecture
    context.read<ProfileSetupProvider>().setStep1Data(
      _nameController.text.trim(), 
      _locationController.text.trim(),
    );

    // Push into Step 2
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const DataGatheringStep2Screen()),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, 
    FocusNode focusNode, 
    IconData icon, 
    String hint, 
    Color activeColor,
    {Widget? suffixIcon, bool readOnly = false, VoidCallback? onTap}
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: focusNode.hasFocus ? activeColor : Colors.grey.shade300, 
          width: focusNode.hasFocus ? 2.0 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: focusNode.hasFocus ? activeColor.withValues(alpha: 0.25) : Colors.transparent,
            blurRadius: focusNode.hasFocus ? 20 : 0,
            spreadRadius: focusNode.hasFocus ? 4 : 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
        child: TextField(
        controller: controller,
        focusNode: focusNode,
        readOnly: readOnly,
        onTap: onTap,
        style: const TextStyle(fontSize: 18, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(
              icon,
              color: focusNode.hasFocus ? activeColor : const Color(0xFFFF9E81),
              size: 26,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFFF7A66), size: 28),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Progress Bar UI
                    const Text(
                      'Step 1/4',
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
                        value: 0.25, 
                        backgroundColor: Colors.grey.shade200,
                        color: const Color(0xFFFF7A66),
                        minHeight: 6,
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    const Text(
                      "Tell us about\nyourself",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        color: Color(0xFF333A44),
                      ),
                    ),
                    
                    const SizedBox(height: 48),

                    // Inputs
                    _buildTextField(
                      _nameController, 
                      _nameFocus, 
                      Icons.person, 
                      "Full Name", 
                      const Color(0xFFFF7A66)
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      _locationController, 
                      _locFocus, 
                      Icons.location_on, 
                      "Location", 
                      const Color(0xFF38B2AC), // Teal for location focus glow
                      readOnly: true,
                      onTap: _fetchLocation,
                      suffixIcon: _isFetchingLocation 
                         ? const Padding(
                             padding: EdgeInsets.all(14.0),
                             child: SizedBox(
                               width: 24, height: 24, 
                               child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF38B2AC))
                             )
                           )
                         : null, // Zero buttons on the right when it's not currently fetching!
                    ),

                    const Spacer(),

                    // Continue Button
                    Container(
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
                    const SizedBox(height: 20),
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

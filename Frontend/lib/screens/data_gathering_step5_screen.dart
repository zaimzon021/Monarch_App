import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_setup_provider.dart';
import 'data_gathering_step6_screen.dart';

class DataGatheringStep5Screen extends StatefulWidget {
  const DataGatheringStep5Screen({super.key});

  @override
  State<DataGatheringStep5Screen> createState() => _DataGatheringStep5ScreenState();
}

class _DataGatheringStep5ScreenState extends State<DataGatheringStep5Screen> {
  String _selectedTest = 'IELTS';
  double _score = 7.5;
  final TextEditingController _scoreController = TextEditingController();

  final List<String> _testTypes = ['IELTS', 'TOEFL', 'PTE', 'Duolingo'];

  @override
  void initState() {
    super.initState();
    _scoreController.text = _score.toString();
  }

  @override
  void dispose() {
    _scoreController.dispose();
    super.dispose();
  }

  void _updateScore(double value) {
    setState(() {
      _score = value;
      // Round to nearest half or integer based on test
      if (_selectedTest == 'IELTS') {
        _score = (value * 2).round() / 2.0;
        _scoreController.text = _score.toStringAsFixed(1);
      } else {
        _score = value.roundToDouble();
        _scoreController.text = _score.toInt().toString();
      }
    });
  }

  double get _minScore {
    switch (_selectedTest) {
      case 'IELTS': return 4.0;
      case 'TOEFL': return 0.0;
      case 'PTE': return 10.0;
      case 'Duolingo': return 10.0;
      default: return 0.0;
    }
  }

  double get _maxScore {
    switch (_selectedTest) {
      case 'IELTS': return 9.0;
      case 'TOEFL': return 120.0;
      case 'PTE': return 90.0;
      case 'Duolingo': return 160.0;
      default: return 100.0;
    }
  }

  int get _divisions {
    switch (_selectedTest) {
      case 'IELTS': return 10; // (9.0 - 4.0) / 0.5
      case 'TOEFL': return 120;
      case 'PTE': return 80;
      case 'Duolingo': return 150;
      default: return 100;
    }
  }

  void _submit() {
    // Save to Provider
    context.read<ProfileSetupProvider>().setStep5Data([
      {
        "test": _selectedTest,
        "score": _score,
      }
    ]);

    // Navigate to Step 6
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const DataGatheringStep6Screen()),
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
                      '5/7',
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
                        value: 0.71, 
                        backgroundColor: Colors.grey.shade200,
                        color: const Color(0xFFFF7A66),
                        minHeight: 6,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    const Text(
                      "Language\nproficiency",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        color: Color(0xFF1A202C),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Select your test type",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                    const SizedBox(height: 32),

                    // Test Type Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      child: Row(
                        children: _testTypes.map((test) {
                          final isSelected = _selectedTest == test;
                          return Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedTest = test;
                                  // Set a default score when switching
                                  if (test == 'IELTS') _score = 7.0;
                                  if (test == 'TOEFL') _score = 90.0;
                                  if (test == 'PTE') _score = 65.0;
                                  if (test == 'Duolingo') _score = 110.0;
                                  _scoreController.text = _selectedTest == 'IELTS' ? _score.toStringAsFixed(1) : _score.toInt().toString();
                                });
                              },
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                    decoration: BoxDecoration(
                                      color: isSelected ? null : Colors.white,
                                      gradient: isSelected 
                                        ? const LinearGradient(
                                            colors: [Color(0xFFFF7A66), Color(0xFFFF9E81)],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          )
                                        : null,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isSelected ? Colors.transparent : const Color(0xFFFF7A66),
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        if (isSelected)
                                          BoxShadow(
                                            color: const Color(0xFFFF7A66).withValues(alpha: 0.3),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          )
                                      ],
                                    ),
                                    child: Text(
                                      test,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? Colors.white : const Color(0xFFFF7A66),
                                      ),
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
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Score Input
                    const Text(
                      "Your Score",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A202C),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF38B2AC), width: 2), // Teal border
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _scoreController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A202C)),
                              onChanged: (val) {
                                final parsed = double.tryParse(val);
                                if (parsed != null) {
                                  setState(() {
                                    if (parsed >= _minScore && parsed <= _maxScore) {
                                      _score = parsed;
                                    }
                                  });
                                }
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(Icons.star, color: const Color(0xFFFF7A66).withValues(alpha: 0.2), size: 36),
                                const Icon(Icons.verified, color: Color(0xFF38B2AC), size: 28),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Slider
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFFFF7A66),
                        inactiveTrackColor: Colors.grey.shade200,
                        trackHeight: 8.0,
                        thumbColor: Colors.white,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0, elevation: 4),
                        overlayColor: const Color(0xFFFF7A66).withValues(alpha: 0.2),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
                      ),
                      child: Slider(
                        value: _score.clamp(_minScore, _maxScore),
                        min: _minScore,
                        max: _maxScore,
                        divisions: _divisions,
                        onChanged: _updateScore,
                      ),
                    ),

                    // Value Markers below Slider
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_selectedTest == 'IELTS' ? _minScore.toStringAsFixed(1) : _minScore.toInt().toString(), 
                               style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
                          Text(_selectedTest == 'IELTS' ? _maxScore.toStringAsFixed(1) : _maxScore.toInt().toString(), 
                               style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
                        ],
                      ),
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

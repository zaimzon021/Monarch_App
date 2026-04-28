import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Triggers the state, holds the UI loading block, executes the safe network request
  Future<bool> sendOtp(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Force the UI to show the loading spinner immediately

    try {
      await _authService.sendOtp(email);
      
      _isLoading = false;
      notifyListeners();
      return true; // Success!
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false; // Failure!
    }
  }

  // Completes the OTP cycle, saves the token entirely locally, and directs architecture.
  Future<bool?> verifyOtp(String email, String otp) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _authService.verifyOtp(email, otp);
      
      // Memory Persistence Core Request: Log them in forever on this device
      if (data['token'] != null) {
         final prefs = await SharedPreferences.getInstance();
         await prefs.setString('jwt_token', data['token']);
         await prefs.setString('user_email', email);
      }

      _isLoading = false;
      notifyListeners();
      return data['profileCompleted'] == true; // Signals routing logic beautifully
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return null; // A complete failure (network / wrong code combo)
    }
  }
  
  // Clean up error state if user retries gracefully
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }
}

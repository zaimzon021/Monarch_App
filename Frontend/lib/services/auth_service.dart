import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // If you run 'adb reverse tcp:3000 tcp:3000' in your terminal, 
  // your physical phone will magically be able to read this exactly as written!
  // Otherwise, change this to your computer's local Wi-Fi IP address (e.g. 192.168.1.10)
  static const String _baseUrl = 'https://monarch-app.onrender.com/api/auth';

  Future<void> sendOtp(String email) async {
    final url = Uri.parse('$_baseUrl/send-otp');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      print("NODEJS RESPONSE [sendOtp]: ${response.statusCode} | ${response.body}");
      
      // Best-in-class error handling: Parse the Node.js backend error precisely
      if (response.statusCode != 200 && response.statusCode != 201) {
        String errorMessage = 'Failed to connect to the server.';
        try {
          final data = jsonDecode(response.body);
          if (data['message'] != null) {
            errorMessage = data['message'];
          }
        } catch (_) {
          // If the backend threw a raw HTML error page instead of JSON, we catch it securely
          errorMessage = 'Server returned error code: ${response.statusCode}';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      // Differentiate between generic crash/offline and strict backend Exceptions
      if (e is Exception && e.toString().contains('Exception:')) {
        throw Exception(e.toString().replaceAll('Exception: ', '')); // Clean throw
      } else {
        throw Exception('Network error: Ensure backend is running and reachable.');
      }
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    final url = Uri.parse('$_baseUrl/verify-otp');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body); // Return exactly what the NodeJS server provided
      } else {
        String errorMessage = 'Invalid OTP or server error.';
        try {
          final data = jsonDecode(response.body);
          if (data['message'] != null) errorMessage = data['message'];
        } catch (_) {}
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is Exception && e.toString().contains('Exception:')) {
        throw Exception(e.toString().replaceAll('Exception: ', '')); 
      } else {
        throw Exception('Network error: Ensure backend is running and reachable.');
      }
    }
  }
}

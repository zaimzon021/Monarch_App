import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static const String _baseUrl = 'http://127.0.0.1:3000/api/profile';

  Future<Map<String, dynamic>> createProfile(Map<String, dynamic> profileData) async {
    final url = Uri.parse('$_baseUrl/create-profile');
    
    try {
      // Grab token if needed by the backend (best practice)
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(profileData),
      );

      print("NODEJS RESPONSE [createProfile]: ${response.statusCode} | ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['userData'] != null) {
          return data['userData'];
        } else {
          throw Exception("Invalid response structure from server.");
        }
      } else {
        String errorMessage = 'Failed to create profile.';
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

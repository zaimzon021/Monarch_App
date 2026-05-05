import 'dart:convert';
import 'package:http/http.dart' as http;

class UniversityService {
  static const String _baseUrl = 'https://monarch-app.onrender.com/api/universities';

  static Future<Map<String, dynamic>?> getRequirements(String uniId) async {
    final url = Uri.parse('$_baseUrl/$uniId/requirements');
    
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true) {
          return decoded['data'];
        }
      }
    } catch (e) {
      print("Error fetching requirements: $e. Returning null.");
    }
    
    return null;
  }

  static Future<Map<String, dynamic>> getUniversityLink(String uniId) async {
    final url = Uri.parse('$_baseUrl/$uniId/link');
    
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true) {
          return decoded['data'];
        }
      }
    } catch (e) {
      print("Error fetching link: $e. Returning mock data.");
    }
    
    return {
      "uniId": uniId,
      "name": "Politecnico di Milano (PoliMi)",
      "applyUrl": "https://www.polimi.it/en/international-prospective-students"
    };
  }
}

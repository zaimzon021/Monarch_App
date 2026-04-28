import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  // Returns formatted location (e.g., "Lahore, Pakistan") or null if any error occurs
  static Future<String?> getCurrentLocation() async {
    try {
      // 1. Check if GPS is physically disabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null; 

      // 2. Check Permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Trigger OS permission pop-up
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      
      if (permission == LocationPermission.deniedForever) return null; 

      // 3. Fetch Coordinates (with a firm timeout so it doesn't freeze forever)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 15),
      );

      // 4. Decode Coordinates into Human-Readable City/Country text
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String city = place.locality ?? place.subAdministrativeArea ?? '';
        String country = place.country ?? '';
        
        if (city.isNotEmpty && country.isNotEmpty) {
          return "$city, $country";
        } else if (city.isNotEmpty) {
           return city;
        } else if (country.isNotEmpty) {
           return country;
        }
      }
      return null;
    } catch (e) {
      // Catches random OS crashes or coordinate decoding failures cleanly
      return null;
    }
  }
}

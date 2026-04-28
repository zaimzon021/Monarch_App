import 'package:flutter/material.dart';

class ProfileSetupProvider extends ChangeNotifier {
  String _fullName = '';
  String _location = '';
  String _academicLevel = ''; 
  double _gpa = 3.5; 

  String get fullName => _fullName;
  String get location => _location;
  String get academicLevel => _academicLevel;
  double get gpa => _gpa;

  void setStep1Data(String name, String loc) {
    _fullName = name;
    _location = loc;
    notifyListeners();
  }

  void setStep2Data(String academicLvl) {
    _academicLevel = academicLvl;
    notifyListeners();
  }

  void setStep3Data(double gpaVal) {
    _gpa = gpaVal;
    notifyListeners();
  }
}

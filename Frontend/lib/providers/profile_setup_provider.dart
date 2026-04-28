import 'package:flutter/material.dart';

class ProfileSetupProvider extends ChangeNotifier {
  String _fullName = '';
  String _location = '';
  String _academicLevel = ''; 
  double _gpa = 3.5; 
  List<String> _studyDestinations = [];
  List<Map<String, dynamic>> _languageProficiency = [];
  String _fundingType = '';
  List<String> _entranceExams = [];

  String get fullName => _fullName;
  String get location => _location;
  String get academicLevel => _academicLevel;
  double get gpa => _gpa;
  List<String> get studyDestinations => _studyDestinations;
  List<Map<String, dynamic>> get languageProficiency => _languageProficiency;
  String get fundingType => _fundingType;
  List<String> get entranceExams => _entranceExams;

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

  void setStep4Data(List<String> destinations) {
    _studyDestinations = destinations;
    notifyListeners();
  }

  void setStep5Data(List<Map<String, dynamic>> proficiency) {
    _languageProficiency = proficiency;
    notifyListeners();
  }

  void setStep6Data(String funding) {
    _fundingType = funding;
    notifyListeners();
  }

  void setStep7Data(List<String> exams) {
    _entranceExams = exams;
    notifyListeners();
  }
}

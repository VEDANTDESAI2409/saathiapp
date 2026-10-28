import 'package:flutter/material.dart';

class CityProvider extends ChangeNotifier {
  String _selectedCity = 'Ahmedabad';

  String get selectedCity => _selectedCity;

  void setCity(String city) {
    if (_selectedCity != city) {
      _selectedCity = city;
      notifyListeners();
    }
  }
}

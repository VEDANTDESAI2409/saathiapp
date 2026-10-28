import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _prefLanguageKey = 'selected_language_code';

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString(_prefLanguageKey) ?? 'en';
    _locale = Locale(lang);
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    if (['en', 'gu', 'hi'].contains(languageCode)) {
      _locale = Locale(languageCode);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefLanguageKey, languageCode);
      notifyListeners();
    }
  }
}

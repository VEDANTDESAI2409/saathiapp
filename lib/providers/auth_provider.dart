import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  UserModel? _currentUser;
  bool _isLoading = true;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    initUser();
  }

  Future<void> initUser() async {
    _isLoading = true;
    notifyListeners();

    _currentUser = await _authRepository.getCurrentUser();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> login(String identifier, String password) async {
    _isLoading = true;
    notifyListeners();

    _currentUser = await _authRepository.loginUser(identifier, password);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setRegisteredCity(String city) async {
    if (_currentUser == null) return;
    _currentUser = await _authRepository.updateRegisteredCity(
      _currentUser!.id,
      city,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('preferred_city', city);

    notifyListeners();
  }

  Future<void> updateProfile(UserModel updated) async {
    _currentUser = await _authRepository.updateUserProfile(updated);
    notifyListeners();
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _currentUser = null;
    notifyListeners();
  }
}

import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  User? _user;

  bool get isAuthenticated => _isAuthenticated;
  User? get user => _user;

  bool _remember = false;

  bool get remember => _remember;

  set remember(bool value) {
    _remember = value;
    notifyListeners();
  }

  AuthProvider() {
    checkAuthentication();
  }

  Future<void> checkAuthentication() async {
    _isAuthenticated = await AuthService.isLoggedIn();
    log("message==_isAuthenticated=${_isAuthenticated}");
    if (_isAuthenticated) {
      _user = await AuthService.getUserProfile();
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final result = await AuthService.login(email, password);
    if (result['success']) {
      _isAuthenticated = true;
      _user = await AuthService.getUserProfile();
      notifyListeners();
    }
    return result;
  }

  Future<Map<String, dynamic>> register(
      String firstName,
      String lastName,
      String email,
      String userName,
      String password,
      String confirmPassword,
      ) async {
    final result = await AuthService.register(firstName, lastName, email, userName, password, confirmPassword);
    return result;
  }

  Future<void> logout() async {
    await AuthService.logout();
    _isAuthenticated = false;
    _user = null;
    notifyListeners();
  }

  Future<void> updateUserProfile(User updatedUser, {File? file}) async {
    final result = await AuthService.updateProfile(updatedUser,avatar: file);
    if (result['success']) {
      _user = updatedUser;
      notifyListeners();
    }
  }
}
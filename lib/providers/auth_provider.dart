import 'package:flutter/material.dart';
import '../core/utils/shared_prefs.dart';

class AuthProvider extends ChangeNotifier {
  // Simulated user store
  final Map<String, String> _users = {
    'user@example.com': '1234',
    'raj@example.com' : '12341234'
  };

  String? _currentUserEmail;

  String? get currentUser => _currentUserEmail;

  bool login(String email, String password) {
    if (_users.containsKey(email) && _users[email] == password) {
      _currentUserEmail = email;
      SharedPrefs.setBool('isLoggedIn', true);
      notifyListeners();
      return true;
    }
    return false;
  }

  bool register(String email, String password) {
    if (_users.containsKey(email)) {
      return false; // user already exists
    }
    _users[email] = password;
    _currentUserEmail = email;
    SharedPrefs.setBool('isLoggedIn', true);
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUserEmail = null;
    SharedPrefs.setBool('isLoggedIn', false);
    notifyListeners();
  }
}

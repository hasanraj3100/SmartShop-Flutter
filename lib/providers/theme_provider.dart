import 'package:flutter/material.dart';
import '../core/utils/shared_prefs.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode;

  ThemeProvider(this._isDarkMode);

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    SharedPrefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }
}

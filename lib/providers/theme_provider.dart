import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  // Supports both naming conventions used across main.dart and settings_screen.dart
  bool get isDarkMode => _isDarkMode;
  bool get isDark => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void toggle([bool? value]) {
    if (value != null) {
      _isDarkMode = value;
    } else {
      _isDarkMode = !_isDarkMode;
    }
    notifyListeners();
  }
}

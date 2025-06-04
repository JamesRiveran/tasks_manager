import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeMode {
  light,
  dark,
  auto,
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.auto;
  bool _isDark = false;

  ThemeProvider() {
    _loadThemeMode();
    _updateThemeBasedOnTime();
  }

  bool get isDark => _isDark;
  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    _updateThemeBasedOnTime();
    _saveThemeMode();
    notifyListeners();
  }

  void _updateThemeBasedOnTime() {
    if (_themeMode == ThemeMode.auto) {
      final hour = DateTime.now().hour;
      _isDark = hour >= 18 || hour < 6;
    } else {
      _isDark = _themeMode == ThemeMode.dark;
    }
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getInt('themeMode') ?? 2; 
    _themeMode = ThemeMode.values[mode];
    _updateThemeBasedOnTime();
    notifyListeners();
  }

  Future<void> _saveThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', _themeMode.index);
  }

  void checkTimeBasedTheme() {
    if (_themeMode == ThemeMode.auto) {
      final wasThemeDark = _isDark;
      _updateThemeBasedOnTime();
      if (wasThemeDark != _isDark) {
        notifyListeners();
      }
    }
  }
}
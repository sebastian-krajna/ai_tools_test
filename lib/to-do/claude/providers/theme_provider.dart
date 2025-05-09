import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

/// Provider to manage the app's theme
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  
  /// Constructor loads the saved theme preference
  ThemeProvider() {
    _loadThemePreference();
  }
  
  /// Get the current theme mode
  ThemeMode get themeMode => _themeMode;
  
  /// Get the light theme
  ThemeData get lightTheme => AppConstants.lightTheme;
  
  /// Get the dark theme
  ThemeData get darkTheme => AppConstants.darkTheme;
  
  /// Is the dark mode currently active
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  /// Set a new theme mode
  Future<void> setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    notifyListeners();
    
    // Save the preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.themePreferenceKey, _themeModeToInt(themeMode));
  }
  
  /// Toggle between light and dark modes
  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    await setThemeMode(newMode);
  }
  
  /// Load the saved theme preference
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final storedTheme = prefs.getInt(AppConstants.themePreferenceKey);
    
    if (storedTheme != null) {
      _themeMode = _intToThemeMode(storedTheme);
      notifyListeners();
    }
  }
  
  /// Convert ThemeMode to int for storage
  int _themeModeToInt(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 0;
      case ThemeMode.dark:
        return 1;
      case ThemeMode.system:
        return 2;
    }
  }
  
  /// Convert stored int to ThemeMode
  ThemeMode _intToThemeMode(int value) {
    switch (value) {
      case 0:
        return ThemeMode.light;
      case 1:
        return ThemeMode.dark;
      case 2:
      default:
        return ThemeMode.system;
    }
  }
}
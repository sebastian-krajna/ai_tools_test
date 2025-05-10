import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Provider for managing app theme settings
class ThemeProvider extends ChangeNotifier {
  static const String _themeBoxName = 'theme_settings';
  static const String _isDarkModeKey = 'is_dark_mode';
  static const String _useSystemThemeKey = 'use_system_theme';
  
  late Box _themeBox;
  bool _isDarkMode = false;
  bool _useSystemTheme = true;
  
  /// Initialize the theme provider
  Future<void> init() async {
    // Open the theme settings box
    _themeBox = await Hive.openBox(_themeBoxName);
    
    // Load saved theme settings
    _useSystemTheme = _themeBox.get(_useSystemThemeKey, defaultValue: true);
    _isDarkMode = _useSystemTheme 
        ? _getSystemThemeMode() 
        : _themeBox.get(_isDarkModeKey, defaultValue: false);
    
    notifyListeners();
  }
  
  /// Get the current theme mode
  ThemeMode get themeMode {
    if (_useSystemTheme) {
      return ThemeMode.system;
    }
    return _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }
  
  /// Get whether dark mode is active
  bool get isDarkMode => _isDarkMode;
  
  /// Get whether system theme setting is used
  bool get useSystemTheme => _useSystemTheme;
  
  /// Set dark mode
  Future<void> setDarkMode(bool value) async {
    if (_isDarkMode == value) return;
    
    _isDarkMode = value;
    await _themeBox.put(_isDarkModeKey, value);
    notifyListeners();
  }
  
  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    await setDarkMode(!_isDarkMode);
  }
  
  /// Set whether to use system theme settings
  Future<void> setUseSystemTheme(bool value) async {
    if (_useSystemTheme == value) return;
    
    _useSystemTheme = value;
    await _themeBox.put(_useSystemThemeKey, value);
    
    if (value) {
      // Update theme based on system settings
      _isDarkMode = _getSystemThemeMode();
    }
    
    notifyListeners();
  }
  
  /// Get system theme mode (light vs dark)
  bool _getSystemThemeMode() {
    final brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }
  
  /// Get light theme data
  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.blue,
      brightness: Brightness.light,
    );
  }
  
  /// Get dark theme data
  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.blue,
      brightness: Brightness.dark,
    );
  }
}
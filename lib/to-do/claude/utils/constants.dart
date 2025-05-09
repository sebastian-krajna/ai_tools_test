import 'package:flutter/material.dart';
import '../models/task.dart';

/// Constants for the app, including theme data and colors
class AppConstants {
  // Storage keys
  static const String tasksBoxName = 'tasks';
  static const String themePreferenceKey = 'themeMode';
  
  // UI constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double cornerRadius = 12.0;
  
  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 300);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 500);
  
  // Theme data
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
  );
  
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
  );
  
  // Priority colors
  static Color getPriorityColor(TaskPriority priority, {bool isDarkMode = false}) {
    final baseOpacity = isDarkMode ? 0.8 : 1.0;
    
    switch (priority) {
      case TaskPriority.low:
        return Colors.green.withOpacity(baseOpacity);
      case TaskPriority.medium:
        return Colors.orange.withOpacity(baseOpacity);
      case TaskPriority.high:
        return Colors.red.withOpacity(baseOpacity);
    }
  }
}
import 'package:flutter/material.dart';
import '../models/task.dart';

/// App color constants
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF6750A4);
  static const Color onPrimary = Colors.white;
  static const Color primaryContainer = Color(0xFFEADDFF);
  static const Color onPrimaryContainer = Color(0xFF21005E);
  
  // Secondary colors
  static const Color secondary = Color(0xFF625B71);
  static const Color onSecondary = Colors.white;
  static const Color secondaryContainer = Color(0xFFE8DEF8);
  static const Color onSecondaryContainer = Color(0xFF1E192B);
  
  // Tertiary colors
  static const Color tertiary = Color(0xFF7E5260);
  static const Color onTertiary = Colors.white;
  static const Color tertiaryContainer = Color(0xFFFFD9E3);
  static const Color onTertiaryContainer = Color(0xFF31101D);
  
  // Error colors
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Colors.white;
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF410002);
  
  // Background colors
  static const Color background = Color(0xFFFFFBFF);
  static const Color onBackground = Color(0xFF1C1B1E);
  static const Color surface = Color(0xFFFFFBFF);
  static const Color onSurface = Color(0xFF1C1B1E);
  
  // Priority colors
  static const Color lowPriority = Color(0xFF4CAF50);
  static const Color mediumPriority = Color(0xFFFFC107);
  static const Color highPriority = Color(0xFFF44336);
  
  /// Get color for a task priority
  static Color getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return lowPriority;
      case TaskPriority.medium:
        return mediumPriority;
      case TaskPriority.high:
        return highPriority;
    }
  }
}

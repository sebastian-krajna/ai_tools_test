import 'package:flutter/material.dart';
import '../models/task.dart';

/// Utility class for app theme settings
class AppTheme {
  /// Get the color scheme for the app based on brightness
  static ColorScheme getColorScheme(BuildContext context, Brightness brightness) {
    return ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: brightness,
    );
  }
  
  /// Get theme data for the app
  static ThemeData getThemeData(BuildContext context, {bool isDarkMode = false}) {
    final brightness = isDarkMode ? Brightness.dark : Brightness.light;
    final colorScheme = getColorScheme(context, brightness);
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
  
  /// Get a color for a priority level
  static Color getPriorityColor(BuildContext context, TaskPriority priority) {
    final colorScheme = Theme.of(context).colorScheme;
    
    switch (priority) {
      case TaskPriority.low:
        return Colors.green.withOpacity(0.8);
      case TaskPriority.medium:
        return Colors.orange.withOpacity(0.8);
      case TaskPriority.high:
        return Colors.red.withOpacity(0.8);
    }
  }
  
  /// Get a lighter background color for a priority level
  static Color getPriorityBackgroundColor(BuildContext context, TaskPriority priority) {
    final colorScheme = Theme.of(context).colorScheme;
    
    switch (priority) {
      case TaskPriority.low:
        return Colors.green.withOpacity(0.1);
      case TaskPriority.medium:
        return Colors.orange.withOpacity(0.1);
      case TaskPriority.high:
        return Colors.red.withOpacity(0.1);
    }
  }
  
  /// Get color for due date based on its status
  static Color getDueDateColor(BuildContext context, DateTime? dueDate) {
    if (dueDate == null) return Colors.grey;
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDateTime = DateTime(dueDate.year, dueDate.month, dueDate.day);
    
    if (dueDateTime.isBefore(today)) {
      return Colors.red;  // Overdue
    } else if (dueDateTime.isAtSameMomentAs(today)) {
      return Colors.orange;  // Due today
    } else if (dueDateTime.difference(today).inDays <= 2) {
      return Colors.amber;  // Due soon
    } else {
      return Colors.green;  // Due in the future
    }
  }
}
import 'package:flutter/material.dart';
import '../models/task.dart';

/// Utility class for working with task priorities
class PriorityHelper {
  /// Get a color associated with a priority level
  static Color getColorForPriority(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
    }
  }
  
  /// Get an icon associated with a priority level
  static IconData getIconForPriority(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Icons.arrow_downward;
      case TaskPriority.medium:
        return Icons.remove;
      case TaskPriority.high:
        return Icons.arrow_upward;
    }
  }
  
  /// Get a list of all priority options with their display names
  static List<Map<String, dynamic>> getPriorityOptions() {
    return [
      {
        'value': TaskPriority.low,
        'label': 'Low',
        'icon': getIconForPriority(TaskPriority.low),
        'color': getColorForPriority(TaskPriority.low),
      },
      {
        'value': TaskPriority.medium,
        'label': 'Medium',
        'icon': getIconForPriority(TaskPriority.medium),
        'color': getColorForPriority(TaskPriority.medium),
      },
      {
        'value': TaskPriority.high,
        'label': 'High',
        'icon': getIconForPriority(TaskPriority.high),
        'color': getColorForPriority(TaskPriority.high),
      },
    ];
  }
}

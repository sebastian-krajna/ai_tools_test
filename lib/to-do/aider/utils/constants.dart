import 'package:flutter/material.dart';
import '../models/task.dart';

/// Application constants
class AppConstants {
  // App name
  static const String appName = 'Todo App';
  
  // Hive box names
  static const String tasksBoxName = 'tasks';
  
  // Priority colors
  static const Map<Priority, Color> priorityColors = {
    Priority.low: Colors.green,
    Priority.medium: Colors.orange,
    Priority.high: Colors.red,
  };
  
  // Priority labels
  static const Map<Priority, String> priorityLabels = {
    Priority.low: 'Low',
    Priority.medium: 'Medium',
    Priority.high: 'High',
  };
  
  // Priority icons
  static const Map<Priority, IconData> priorityIcons = {
    Priority.low: Icons.arrow_downward,
    Priority.medium: Icons.remove,
    Priority.high: Icons.arrow_upward,
  };
  
  // Sort method labels
  static const Map<String, String> sortMethodLabels = {
    'dueDate': 'Due Date',
    'priority': 'Priority',
    'title': 'Title',
    'status': 'Status',
  };
}

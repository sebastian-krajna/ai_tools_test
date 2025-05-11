import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

/// Service responsible for handling data persistence operations
class StorageService {
  static const String _tasksKey = 'tasks';
  
  /// Save tasks to local storage
  Future<void> saveTasks(List<Task> tasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
      await prefs.setStringList(_tasksKey, tasksJson);
    } catch (e) {
      // Log error and rethrow for proper error handling upstream
      print('Error saving tasks: $e');
      throw Exception('Failed to save tasks: $e');
    }
  }

  /// Load tasks from local storage
  Future<List<Task>> loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getStringList(_tasksKey) ?? [];
      
      return tasksJson
          .map((taskJson) => Task.fromJson(jsonDecode(taskJson)))
          .toList();
    } catch (e) {
      // Log error and return empty list to prevent app crash
      print('Error loading tasks: $e');
      return [];
    }
  }

  /// Clear all tasks from storage (useful for testing or reset functionality)
  Future<void> clearTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tasksKey);
    } catch (e) {
      print('Error clearing tasks: $e');
      throw Exception('Failed to clear tasks: $e');
    }
  }
}

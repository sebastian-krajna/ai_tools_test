import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageService {
  static const String _tasksKey = 'tasks';

  // Save tasks to SharedPreferences
  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList(_tasksKey, tasksJson);
  }

  // Load tasks from SharedPreferences
  Future<List<Task>> loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getStringList(_tasksKey) ?? [];
      
      return tasksJson
          .map((taskJson) => Task.fromJson(jsonDecode(taskJson)))
          .toList();
    } catch (e) {
      // Handle error and return empty list if there's an issue
      print('Error loading tasks: $e');
      return [];
    }
  }
}

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/task.dart';

class StorageService {
  static const _tasksKey = 'tasks';

  Future<List<Task>> loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksString = prefs.getString(_tasksKey);
      if (tasksString == null) {
        return [];
      }
      final List<dynamic> tasksJson = jsonDecode(tasksString);
      return tasksJson.map((json) {
        return Task(
          id: json['id'],
          title: json['title'],
          description: json['description'],
          priority: Priority.values.byName(json['priority']),
          dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
          isCompleted: json['isCompleted'],
        );
      }).toList();
    } catch (e) {
      // Handle error (e.g., log it)
      print("Error loading tasks from storage: $e");
      return []; // Return an empty list in case of error
    }
  }

  Future<void> saveTasks(List<Task> tasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = tasks.map((task) {
        return {
          'id': task.id,
          'title': task.title,
          'description': task.description,
          'priority': task.priority.name,
          'dueDate': task.dueDate?.toIso8601String(),
          'isCompleted': task.isCompleted,
        };
      }).toList();
      final tasksString = jsonEncode(tasksJson);
      await prefs.setString(_tasksKey, tasksString);
    } catch (e) {
      // Handle error
      print("Error saving tasks to storage: $e");
    }
  }
}
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

/// Provider class for managing task state
class TaskProvider with ChangeNotifier {
  /// List of all tasks
  List<Task> _tasks = [];
  
  /// Current sorting method
  SortMethod _sortMethod = SortMethod.priority;

  /// Gets the current list of tasks
  List<Task> get tasks {
    final sortedTasks = List<Task>.from(_tasks);
    
    // Sort tasks based on the current sort method
    switch (_sortMethod) {
      case SortMethod.priority:
        sortedTasks.sort((a, b) {
          // First sort by completion status
          if (a.isCompleted != b.isCompleted) {
            return a.isCompleted ? 1 : -1;
          }
          // Then sort by priority (high to low)
          return b.priority.index - a.priority.index;
        });
        break;
      case SortMethod.dueDate:
        sortedTasks.sort((a, b) {
          // First sort by completion status
          if (a.isCompleted != b.isCompleted) {
            return a.isCompleted ? 1 : -1;
          }
          // Then sort by due date
          if (a.dueDate == null && b.dueDate == null) {
            return 0;
          } else if (a.dueDate == null) {
            return 1;
          } else if (b.dueDate == null) {
            return -1;
          }
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;
      case SortMethod.completion:
        sortedTasks.sort((a, b) {
          // Sort by completion status
          if (a.isCompleted != b.isCompleted) {
            return a.isCompleted ? 1 : -1;
          }
          return 0;
        });
        break;
    }
    
    return sortedTasks;
  }

  /// Gets the current sort method
  SortMethod get sortMethod => _sortMethod;

  /// Constructor loads tasks from local storage
  TaskProvider() {
    _loadTasks();
  }

  /// Adds a new task to the list
  void addTask(Task task) {
    _tasks.add(task);
    _saveTasks();
    notifyListeners();
  }

  /// Updates an existing task
  void updateTask(String id, Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      _saveTasks();
      notifyListeners();
    }
  }

  /// Deletes a task by its ID
  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _saveTasks();
    notifyListeners();
  }

  /// Toggles the completion status of a task
  void toggleTaskCompletion(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
      _saveTasks();
      notifyListeners();
    }
  }

  /// Changes the current sort method
  void setSortMethod(SortMethod method) {
    _sortMethod = method;
    notifyListeners();
  }

  /// Saves tasks to local storage
  Future<void> _saveTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = _tasks.map((task) => jsonEncode(task.toJson())).toList();
      await prefs.setStringList('tasks', tasksJson);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving tasks: $e');
      }
    }
  }

  /// Loads tasks from local storage
  Future<void> _loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getStringList('tasks') ?? [];
      
      _tasks = tasksJson
          .map((taskJson) => Task.fromJson(jsonDecode(taskJson)))
          .toList();
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading tasks: $e');
      }
      _tasks = [];
    }
  }
}

/// Enum representing the different methods of sorting tasks
enum SortMethod {
  priority,
  dueDate,
  completion,
}

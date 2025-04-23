import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  final String _storageKey = 'tasks';
  bool _isLoading = true;
  
  TaskProvider() {
    _loadTasks();
  }

  bool get isLoading => _isLoading;
  List<Task> get tasks => _tasks;
  
  List<Task> get completedTasks => _tasks.where((task) => task.isCompleted).toList();
  List<Task> get pendingTasks => _tasks.where((task) => !task.isCompleted).toList();

  Future<void> _loadTasks() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getStringList(_storageKey);
      
      if (tasksJson != null) {
        _tasks = tasksJson
            .map((taskJson) => Task.fromJson(json.decode(taskJson)))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = _tasks
          .map((task) => json.encode(task.toJson()))
          .toList();
      
      await prefs.setStringList(_storageKey, tasksJson);
    } catch (e) {
      debugPrint('Error saving tasks: $e');
    }
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    notifyListeners();
    await _saveTasks();
  }

  Future<void> updateTask(Task updatedTask) async {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
      await _saveTasks();
    }
  }

  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
    await _saveTasks();
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(isCompleted: !_tasks[index].isCompleted);
      notifyListeners();
      await _saveTasks();
    }
  }

  List<Task> sortTasks(List<Task> tasks, SortOption sortOption) {
    switch (sortOption) {
      case SortOption.priority:
        return List.from(tasks)
          ..sort((a, b) => b.priority.index.compareTo(a.priority.index));
      case SortOption.dueDate:
        return List.from(tasks)
          ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
      case SortOption.completionStatus:
        return List.from(tasks)
          ..sort((a, b) => a.isCompleted ? 1 : -1);
      default:
        return tasks;
    }
  }
}

enum SortOption {
  priority,
  dueDate,
  completionStatus,
} 
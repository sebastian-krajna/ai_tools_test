import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/storage_service.dart';
import 'package:uuid/uuid.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];
  final StorageService _storageService = StorageService();

  UnmodifiableListView<Task> get tasks => UnmodifiableListView(_tasks);

  TaskProvider() {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final loadedTasks = await _storageService.loadTasks();
      _tasks.addAll(loadedTasks);
      notifyListeners();
    } catch (e) {
      // Handle error (e.g., log it, show a message to the user)
      print("Error loading tasks: $e");
    }
  }

  Future<void> addTask(Task task) async {
    try {
      final newTask = Task(
        id: const Uuid().v4(),
        title: task.title,
        description: task.description,
        priority: task.priority,
        dueDate: task.dueDate,
      );
      _tasks.add(newTask);
      await _storageService.saveTasks(_tasks);
      notifyListeners();
    } catch (e) {
      // Handle error
      print("Error adding task: $e");
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        await _storageService.saveTasks(_tasks);
        notifyListeners();
      }
    } catch (e) {
      // Handle error
      print("Error updating task: $e");
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      _tasks.removeWhere((task) => task.id == taskId);
      await _storageService.saveTasks(_tasks);
      notifyListeners();
    } catch (e) {
      // Handle error
      print("Error deleting task: $e");
    }
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    try {
      final index = _tasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        _tasks[index] = _tasks[index].copyWith(isCompleted: !_tasks[index].isCompleted);
        await _storageService.saveTasks(_tasks);
        notifyListeners();
      }
    } catch (e) {
      // Handle error
      print("Error toggling task completion: $e");
    }
  }

  void sortTasks(SortOption option) {
    // Implement sorting logic based on the SortOption enum
    // You can add an enum to represent different sorting criteria (priority, due date, completion status)
    // and use the `sort` method on the `_tasks` list.
    notifyListeners(); // Notify listeners after sorting
  }
}

enum SortOption { priority, dueDate, completion }
import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/storage_service.dart';

/// Provider class to manage task state using the Provider pattern
class TaskProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  /// Get all tasks
  List<Task> get tasks => _tasks;
  
  /// Check if data is loading
  bool get isLoading => _isLoading;
  
  /// Get current error message, if any
  String? get error => _error;

  /// Initialize the provider by loading tasks from storage
  Future<void> initialize() async {
    _setLoading(true);
    try {
      _tasks = await _storageService.loadTasks();
      _error = null;
    } catch (e) {
      _error = 'Failed to load tasks: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Add a new task
  Future<void> addTask(Task task) async {
    _setLoading(true);
    try {
      _tasks.add(task);
      await _saveTasksToStorage();
      _error = null;
    } catch (e) {
      _error = 'Failed to add task: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Update an existing task
  Future<void> updateTask(Task updatedTask) async {
    _setLoading(true);
    try {
      final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        await _saveTasksToStorage();
        _error = null;
      } else {
        _error = 'Task not found';
      }
    } catch (e) {
      _error = 'Failed to update task: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Delete a task by its ID
  Future<void> deleteTask(String taskId) async {
    _setLoading(true);
    try {
      _tasks.removeWhere((task) => task.id == taskId);
      await _saveTasksToStorage();
      _error = null;
    } catch (e) {
      _error = 'Failed to delete task: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Toggle the completion status of a task
  Future<void> toggleTaskCompletion(String taskId) async {
    _setLoading(true);
    try {
      final index = _tasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        final task = _tasks[index];
        _tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
        await _saveTasksToStorage();
        _error = null;
      } else {
        _error = 'Task not found';
      }
    } catch (e) {
      _error = 'Failed to toggle task completion: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Sort tasks by different criteria
  void sortTasks(SortCriteria criteria) {
    switch (criteria) {
      case SortCriteria.priority:
        _tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case SortCriteria.dueDate:
        _tasks.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;
      case SortCriteria.completed:
        _tasks.sort((a, b) => a.isCompleted == b.isCompleted
            ? 0
            : (a.isCompleted ? 1 : -1));
        break;
      case SortCriteria.title:
        _tasks.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortCriteria.creationDate:
        _tasks.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }
    notifyListeners();
  }

  /// Get tasks filtered by completion status
  List<Task> getTasksByCompletionStatus(bool isCompleted) {
    return _tasks.where((task) => task.isCompleted == isCompleted).toList();
  }

  /// Get tasks filtered by priority
  List<Task> getTasksByPriority(TaskPriority priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }

  /// Helper method to set loading state and notify listeners
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Helper method to save tasks to storage
  Future<void> _saveTasksToStorage() async {
    await _storageService.saveTasks(_tasks);
    notifyListeners();
  }
}

/// Enum defining sort criteria for tasks
enum SortCriteria {
  priority,
  dueDate,
  completed,
  title,
  creationDate,
}

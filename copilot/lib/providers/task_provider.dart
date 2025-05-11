import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/storage_service.dart';

/// Sort options for tasks
enum TaskSortOption {
  priority,
  dueDate,
  completionStatus,
  creationDate,
}

/// Provider class for managing task state using the Provider pattern
class TaskProvider with ChangeNotifier {
  final StorageService _storageService;
  List<Task> _tasks = [];
  TaskSortOption _sortOption = TaskSortOption.creationDate;
  bool _sortAscending = false;

  TaskProvider(this._storageService);

  /// Get all tasks
  List<Task> get tasks => _tasks;

  /// Get the current sort option
  TaskSortOption get sortOption => _sortOption;

  /// Get the current sort direction
  bool get sortAscending => _sortAscending;

  /// Get all tasks sorted according to the current sort option
  List<Task> get sortedTasks {
    final tasksCopy = List<Task>.from(_tasks);
    
    switch (_sortOption) {
      case TaskSortOption.priority:
        tasksCopy.sort((a, b) {
          final comparison = a.priority.index.compareTo(b.priority.index);
          return _sortAscending ? comparison : -comparison;
        });
      
      case TaskSortOption.dueDate:
        tasksCopy.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return _sortAscending ? 1 : -1;
          if (b.dueDate == null) return _sortAscending ? -1 : 1;
          
          final comparison = a.dueDate!.compareTo(b.dueDate!);
          return _sortAscending ? comparison : -comparison;
        });
      
      case TaskSortOption.completionStatus:
        tasksCopy.sort((a, b) {
          final comparison = a.isCompleted == b.isCompleted 
              ? 0 
              : a.isCompleted ? 1 : -1;
          return _sortAscending ? comparison : -comparison;
        });
      
      case TaskSortOption.creationDate:
        tasksCopy.sort((a, b) {
          final comparison = a.createdAt.compareTo(b.createdAt);
          return _sortAscending ? comparison : -comparison;
        });
    }
    
    return tasksCopy;
  }

  /// Set the sort option and direction
  void setSortOption(TaskSortOption option, {bool? ascending}) {
    if (_sortOption == option) {
      _sortAscending = ascending ?? !_sortAscending;
    } else {
      _sortOption = option;
      _sortAscending = ascending ?? false;
    }
    notifyListeners();
  }

  /// Load tasks from storage
  Future<void> loadTasks() async {
    try {
      _tasks = await _storageService.getTasks();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading tasks: $e');
      // Handle error - could implement error reporting here
    }
  }

  /// Add a new task
  Future<void> addTask(Task task) async {
    try {
      await _storageService.saveTask(task);
      _tasks.add(task);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding task: $e');
      // Handle error
    }
  }

  /// Update an existing task
  Future<void> updateTask(Task task) async {
    try {
      await _storageService.updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating task: $e');
      // Handle error
    }
  }

  /// Delete a task
  Future<void> deleteTask(String id) async {
    try {
      await _storageService.deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting task: $e');
      // Handle error
    }
  }

  /// Toggle task completion status
  Future<void> toggleTaskCompletion(String id) async {
    try {
      final index = _tasks.indexWhere((task) => task.id == id);
      if (index != -1) {
        final task = _tasks[index];
        final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
        await updateTask(updatedTask);
      }
    } catch (e) {
      debugPrint('Error toggling task completion: $e');
      // Handle error
    }
  }
}
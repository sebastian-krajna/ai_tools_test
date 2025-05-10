import 'package:flutter/foundation.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/storage_service.dart';

/// Sort options for task list
enum TaskSort {
  priority,
  dueDate,
  title,
  createdAt,
}

/// Filter options for task list
enum TaskFilter {
  all,
  completed,
  active,
}

/// Provider class for managing tasks state
class TaskProvider extends ChangeNotifier {
  final StorageService _storageService;
  List<Task> _tasks = [];
  
  // Current sort and filter options
  TaskSort _currentSort = TaskSort.createdAt;
  TaskFilter _currentFilter = TaskFilter.all;
  bool _sortAscending = false;

  /// Constructor
  TaskProvider(this._storageService);

  /// Initialize the provider and load tasks
  Future<void> init() async {
    await loadTasks();
  }

  /// Get all tasks with current sorting and filtering applied
  List<Task> get tasks {
    // Apply filter
    List<Task> filteredTasks = _tasks.where((task) {
      switch (_currentFilter) {
        case TaskFilter.completed:
          return task.isCompleted;
        case TaskFilter.active:
          return !task.isCompleted;
        case TaskFilter.all:
        default:
          return true;
      }
    }).toList();

    // Apply sorting
    filteredTasks.sort((a, b) {
      int comparison;
      
      switch (_currentSort) {
        case TaskSort.priority:
          comparison = b.priority.index.compareTo(a.priority.index);
          break;
        case TaskSort.dueDate:
          if (a.dueDate == null && b.dueDate == null) {
            comparison = 0;
          } else if (a.dueDate == null) {
            comparison = 1;
          } else if (b.dueDate == null) {
            comparison = -1;
          } else {
            comparison = a.dueDate!.compareTo(b.dueDate!);
          }
          break;
        case TaskSort.title:
          comparison = a.title.toLowerCase().compareTo(b.title.toLowerCase());
          break;
        case TaskSort.createdAt:
        default:
          comparison = b.createdAt.compareTo(a.createdAt);
          break;
      }
      
      // Apply sort direction
      return _sortAscending ? comparison : -comparison;
    });

    return filteredTasks;
  }

  /// Get task by ID
  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get current sort option
  TaskSort get currentSort => _currentSort;

  /// Get current filter option
  TaskFilter get currentFilter => _currentFilter;

  /// Get sort direction
  bool get sortAscending => _sortAscending;

  /// Set sort option
  void setSort(TaskSort sort) {
    // If same sort is selected, toggle direction
    if (_currentSort == sort) {
      _sortAscending = !_sortAscending;
    } else {
      _currentSort = sort;
      // Default sort directions based on type
      _sortAscending = sort == TaskSort.title;
    }
    notifyListeners();
  }

  /// Set filter option
  void setFilter(TaskFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  /// Load all tasks from storage
  Future<void> loadTasks() async {
    try {
      _tasks = _storageService.getAllTasks();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading tasks: $e');
    }
  }

  /// Add a new task
  Future<void> addTask(Task task) async {
    try {
      await _storageService.saveTask(task);
      // Reload tasks from storage to ensure consistency
      await loadTasks();
    } catch (e) {
      debugPrint('Error adding task: $e');
      rethrow;
    }
  }

  /// Update a task
  Future<void> updateTask(Task task) async {
    try {
      await _storageService.saveTask(task);
      await loadTasks();
    } catch (e) {
      debugPrint('Error updating task: $e');
      rethrow;
    }
  }

  /// Toggle task completion
  Future<void> toggleTaskCompletion(String id) async {
    try {
      final task = getTaskById(id);
      if (task != null) {
        final updatedTask = task.toggleCompleted();
        await _storageService.saveTask(updatedTask);
        await loadTasks();
      }
    } catch (e) {
      debugPrint('Error toggling task completion: $e');
      rethrow;
    }
  }

  /// Delete a task
  Future<void> deleteTask(String id) async {
    try {
      await _storageService.deleteTask(id);
      await loadTasks();
    } catch (e) {
      debugPrint('Error deleting task: $e');
      rethrow;
    }
  }

  /// Delete all tasks
  Future<void> deleteAllTasks() async {
    try {
      await _storageService.deleteAllTasks();
      await loadTasks();
    } catch (e) {
      debugPrint('Error deleting all tasks: $e');
      rethrow;
    }
  }
}
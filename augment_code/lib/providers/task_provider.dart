import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';

/// Provider for managing task state
class TaskProvider with ChangeNotifier {
  final TaskRepository _repository;
  List<Task> _tasks = [];
  
  // Sorting options
  TaskSortOption _sortOption = TaskSortOption.dueDate;
  bool _showCompletedFirst = false;

  TaskProvider(this._repository);

  /// Initialize the provider
  Future<void> init() async {
    await _repository.init();
    await loadTasks();
  }

  /// Get all tasks
  List<Task> get tasks => _getSortedTasks();

  /// Get the current sort option
  TaskSortOption get sortOption => _sortOption;

  /// Get whether completed tasks are shown first
  bool get showCompletedFirst => _showCompletedFirst;

  /// Set the sort option
  set sortOption(TaskSortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  /// Set whether completed tasks are shown first
  set showCompletedFirst(bool value) {
    _showCompletedFirst = value;
    notifyListeners();
  }

  /// Load tasks from the repository
  Future<void> loadTasks() async {
    _tasks = _repository.getAllTasks();
    notifyListeners();
  }

  /// Add a new task
  Future<void> addTask(Task task) async {
    await _repository.addTask(task);
    await loadTasks();
  }

  /// Update an existing task
  Future<void> updateTask(Task task) async {
    await _repository.updateTask(task);
    await loadTasks();
  }

  /// Delete a task
  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
    await loadTasks();
  }

  /// Toggle task completion status
  Future<void> toggleTaskCompletion(String id) async {
    final task = _tasks.firstWhere((task) => task.id == id);
    await _repository.toggleTaskCompletion(id, !task.isCompleted);
    await loadTasks();
  }

  /// Get a task by ID
  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get sorted tasks based on the current sort option
  List<Task> _getSortedTasks() {
    final sortedTasks = List<Task>.from(_tasks);
    
    // First sort by completion status if needed
    if (_showCompletedFirst) {
      sortedTasks.sort((a, b) => a.isCompleted == b.isCompleted 
          ? 0 
          : (a.isCompleted ? -1 : 1));
    }
    
    // Then sort by the selected option
    switch (_sortOption) {
      case TaskSortOption.priority:
        sortedTasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case TaskSortOption.dueDate:
        sortedTasks.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;
      case TaskSortOption.title:
        sortedTasks.sort((a, b) => a.title.compareTo(b.title));
        break;
      case TaskSortOption.creationDate:
        sortedTasks.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }
    
    return sortedTasks;
  }
}

/// Enum for task sorting options
enum TaskSortOption {
  priority,
  dueDate,
  title,
  creationDate,
}

/// Extension to get display name for sort options
extension TaskSortOptionExtension on TaskSortOption {
  String get name {
    switch (this) {
      case TaskSortOption.priority:
        return 'Priority';
      case TaskSortOption.dueDate:
        return 'Due Date';
      case TaskSortOption.title:
        return 'Title';
      case TaskSortOption.creationDate:
        return 'Creation Date';
    }
  }
}

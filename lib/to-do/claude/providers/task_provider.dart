import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/storage_service.dart';

/// Sort criteria for task list
enum TaskSortCriteria {
  priority,
  dueDate,
  title,
  creationDate,
  completionStatus
}

/// Provider to manage the state of tasks
class TaskProvider with ChangeNotifier {
  final StorageService _storageService;
  
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;
  TaskSortCriteria _sortCriteria = TaskSortCriteria.creationDate;
  bool _sortAscending = false;
  
  /// Constructor for TaskProvider
  TaskProvider(this._storageService) {
    loadTasks();
  }
  
  /// Get all tasks
  List<Task> get tasks => _sortedTasks;
  
  /// Get only incomplete tasks
  List<Task> get incompleteTasks => _sortedTasks.where((task) => !task.isCompleted).toList();
  
  /// Get only completed tasks
  List<Task> get completedTasks => _sortedTasks.where((task) => task.isCompleted).toList();
  
  /// Get tasks sorted by the current criteria
  List<Task> get _sortedTasks {
    final taskList = List<Task>.from(_tasks);
    
    switch (_sortCriteria) {
      case TaskSortCriteria.priority:
        taskList.sort((a, b) => _sortAscending
            ? a.priority.index.compareTo(b.priority.index)
            : b.priority.index.compareTo(a.priority.index));
        break;
      case TaskSortCriteria.dueDate:
        taskList.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return _sortAscending ? 1 : -1;
          if (b.dueDate == null) return _sortAscending ? -1 : 1;
          return _sortAscending
              ? a.dueDate!.compareTo(b.dueDate!)
              : b.dueDate!.compareTo(a.dueDate!);
        });
        break;
      case TaskSortCriteria.title:
        taskList.sort((a, b) => _sortAscending
            ? a.title.compareTo(b.title)
            : b.title.compareTo(a.title));
        break;
      case TaskSortCriteria.creationDate:
        taskList.sort((a, b) => _sortAscending
            ? a.createdAt.compareTo(b.createdAt)
            : b.createdAt.compareTo(a.createdAt));
        break;
      case TaskSortCriteria.completionStatus:
        taskList.sort((a, b) {
          if (a.isCompleted == b.isCompleted) {
            return a.createdAt.compareTo(b.createdAt);
          }
          return _sortAscending
              ? (a.isCompleted ? 1 : 0) - (b.isCompleted ? 1 : 0)
              : (b.isCompleted ? 1 : 0) - (a.isCompleted ? 1 : 0);
        });
        break;
    }
    
    return taskList;
  }
  
  /// Is data currently loading
  bool get isLoading => _isLoading;
  
  /// Error message if any
  String? get error => _error;
  
  /// Current sort criteria
  TaskSortCriteria get sortCriteria => _sortCriteria;
  
  /// Is the sort order ascending
  bool get sortAscending => _sortAscending;
  
  /// Set the sort criteria
  void setSortCriteria(TaskSortCriteria criteria) {
    if (_sortCriteria == criteria) {
      _sortAscending = !_sortAscending;
    } else {
      _sortCriteria = criteria;
      _sortAscending = true;
    }
    notifyListeners();
  }
  
  /// Load tasks from storage
  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _tasks = _storageService.getAllTasks();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to load tasks: ${e.toString()}';
      notifyListeners();
    }
  }
  
  /// Add a new task
  Future<void> addTask(Task task) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _storageService.addTask(task);
      _tasks.add(task);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to add task: ${e.toString()}';
      notifyListeners();
    }
  }
  
  /// Delete a task
  Future<void> deleteTask(String taskId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _storageService.deleteTask(taskId);
      _tasks.removeWhere((task) => task.id == taskId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to delete task: ${e.toString()}';
      notifyListeners();
    }
  }
  
  /// Update an existing task
  Future<void> updateTask(Task task) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _storageService.updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to update task: ${e.toString()}';
      notifyListeners();
    }
  }
  
  /// Toggle task completion status
  Future<void> toggleTaskCompletion(String taskId) async {
    final task = _tasks.firstWhere((task) => task.id == taskId);
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await updateTask(updatedTask);
  }
  
  /// Get a task by ID
  Task? getTask(String taskId) {
    try {
      return _tasks.firstWhere((task) => task.id == taskId);
    } catch (e) {
      return null;
    }
  }
  
  /// Clear all tasks
  Future<void> clearAllTasks() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _storageService.deleteAllTasks();
      _tasks.clear();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to clear tasks: ${e.toString()}';
      notifyListeners();
    }
  }
}
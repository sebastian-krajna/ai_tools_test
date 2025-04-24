import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/storage_service.dart';

/// Sort options for the task list
enum TaskSortOption {
  priority,
  dueDate,
  status,
  creationDate,
}

/// Provider for managing tasks state
class TaskProvider with ChangeNotifier {
  final StorageService _storageService;
  List<Task> _tasks = [];
  TaskSortOption _sortOption = TaskSortOption.creationDate;
  bool _sortAscending = true;

  /// Constructor that takes a storage service
  TaskProvider(this._storageService) {
    _loadTasks();
  }

  /// Get all tasks
  List<Task> get tasks => _getSortedTasks();

  /// Get the current sort option
  TaskSortOption get sortOption => _sortOption;

  /// Get the current sort direction
  bool get sortAscending => _sortAscending;

  /// Set the sort option and direction
  void setSortOption(TaskSortOption option, {bool? ascending}) {
    _sortOption = option;
    if (ascending != null) {
      _sortAscending = ascending;
    } else {
      // Toggle direction if selecting the same option
      _sortAscending = option == _sortOption ? !_sortAscending : true;
    }
    notifyListeners();
  }

  /// Load tasks from storage
  Future<void> _loadTasks() async {
    _tasks = _storageService.getAllTasks();
    notifyListeners();
  }

  /// Add a new task
  Future<void> addTask(Task task) async {
    await _storageService.saveTask(task);
    _tasks.add(task);
    notifyListeners();
  }

  /// Update an existing task
  Future<void> updateTask(Task task) async {
    await _storageService.saveTask(task);
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  /// Delete a task
  Future<void> deleteTask(String id) async {
    await _storageService.deleteTask(id);
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  /// Toggle the completion status of a task
  Future<void> toggleTaskCompletion(String id) async {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      final task = _tasks[index];
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await updateTask(updatedTask);
    }
  }

  /// Get tasks sorted according to the current sort option
  List<Task> _getSortedTasks() {
    final sortedTasks = List<Task>.from(_tasks);
    
    switch (_sortOption) {
      case TaskSortOption.priority:
        sortedTasks.sort((a, b) => _sortAscending
            ? a.priority.index.compareTo(b.priority.index)
            : b.priority.index.compareTo(a.priority.index));
      case TaskSortOption.dueDate:
        sortedTasks.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return _sortAscending ? 1 : -1;
          if (b.dueDate == null) return _sortAscending ? -1 : 1;
          return _sortAscending
              ? a.dueDate!.compareTo(b.dueDate!)
              : b.dueDate!.compareTo(a.dueDate!);
        });
      case TaskSortOption.status:
        sortedTasks.sort((a, b) => _sortAscending
            ? a.isCompleted.toString().compareTo(b.isCompleted.toString())
            : b.isCompleted.toString().compareTo(a.isCompleted.toString()));
      case TaskSortOption.creationDate:
        sortedTasks.sort((a, b) => _sortAscending
            ? a.createdAt.compareTo(b.createdAt)
            : b.createdAt.compareTo(a.createdAt));
    }
    
    return sortedTasks;
  }

  /// Get tasks filtered by completion status
  List<Task> getFilteredTasks({bool? isCompleted}) {
    if (isCompleted == null) {
      return tasks;
    }
    return tasks.where((task) => task.isCompleted == isCompleted).toList();
  }
}

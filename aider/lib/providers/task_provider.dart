import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../services/storage_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  final StorageService _storageService = StorageService();
  TaskSortOption _sortOption = TaskSortOption.priority;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Task> get tasks => _getSortedTasks();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  TaskSortOption get sortOption => _sortOption;

  // Constructor - load tasks when provider is initialized
  TaskProvider() {
    _loadTasks();
  }

  // Load tasks from storage
  Future<void> _loadTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tasks = await _storageService.loadTasks();
    } catch (e) {
      _errorMessage = 'Failed to load tasks: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save tasks to storage
  Future<void> _saveTasks() async {
    try {
      await _storageService.saveTasks(_tasks);
    } catch (e) {
      _errorMessage = 'Failed to save tasks: $e';
      notifyListeners();
    }
  }

  // Add a new task
  Future<void> addTask(String title, String description, TaskPriority priority, DateTime? dueDate) async {
    final task = Task(
      id: const Uuid().v4(),
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate,
    );

    _tasks.add(task);
    notifyListeners();
    await _saveTasks();
  }

  // Update an existing task
  Future<void> updateTask(Task updatedTask) async {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index >= 0) {
      _tasks[index] = updatedTask;
      notifyListeners();
      await _saveTasks();
    }
  }

  // Delete a task
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
    await _saveTasks();
  }

  // Toggle task completion status
  Future<void> toggleTaskCompletion(String id) async {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index >= 0) {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
      notifyListeners();
      await _saveTasks();
    }
  }

  // Set sort option
  void setSortOption(TaskSortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  // Get sorted tasks based on current sort option
  List<Task> _getSortedTasks() {
    final sortedTasks = List<Task>.from(_tasks);
    
    switch (_sortOption) {
      case TaskSortOption.priority:
        sortedTasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case TaskSortOption.dueDate:
        sortedTasks.sort((a, b) {
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;
      case TaskSortOption.completion:
        sortedTasks.sort((a, b) => a.isCompleted ? 1 : -1);
        break;
    }
    
    return sortedTasks;
  }
}

enum TaskSortOption { priority, dueDate, completion }
